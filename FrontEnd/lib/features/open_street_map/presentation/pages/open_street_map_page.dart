import 'dart:async';

import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:dbnus/features/open_street_map/data/datasources/map_remote_data_source.dart';
import 'package:dbnus/features/open_street_map/data/repositories/map_repository_impl.dart';
import 'package:dbnus/features/open_street_map/domain/entities/route_info.dart';
import 'package:dbnus/features/open_street_map/domain/entities/search_place.dart';
import 'package:dbnus/features/open_street_map/domain/usecases/get_route_usecase.dart';
import 'package:dbnus/features/open_street_map/domain/usecases/search_places_usecase.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/place_details_card.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/route_info_bar.dart';

class OpenStreetMapPage extends StatefulWidget {
  const OpenStreetMapPage({super.key});

  @override
  State<OpenStreetMapPage> createState() => _OpenStreetMapPageState();
}

class _OpenStreetMapPageState extends State<OpenStreetMapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _toSearchController = TextEditingController();
  final TextEditingController _fromSearchController = TextEditingController();
  final FocusNode _toSearchFocus = FocusNode();
  final FocusNode _fromSearchFocus = FocusNode();

  // Clean architecture
  late final SearchPlacesUseCase _searchPlacesUseCase;
  late final GetRouteUseCase _getRouteUseCase;

  // State
  List<SearchPlace> _searchResults = [];
  SearchPlace? _selectedPlace;
  SearchPlace? _fromPlace;
  LatLng? _fromLocation;
  RouteInfo? _routeInfo;
  bool _isSearching = false;
  bool _isLoadingRoute = false;
  bool _showResults = false;
  bool _isFromSearch = false; // true = searching for "from", false = "to"
  bool _usingCurrentLocation = false;
  bool _showDirectionsPanel = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final dataSource = MapRemoteDataSourceImpl();
    final repository = MapRepositoryImpl(remoteDataSource: dataSource);
    _searchPlacesUseCase = SearchPlacesUseCase(repository);
    _getRouteUseCase = GetRouteUseCase(repository);
  }

  @override
  void dispose() {
    _toSearchController.dispose();
    _fromSearchController.dispose();
    _toSearchFocus.dispose();
    _fromSearchFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Search Logic ────────────────────────────────────────

  void _onSearchChanged(String query, {required bool isFrom}) {
    _debounce?.cancel();
    setState(() => _isFromSearch = isFrom);
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isSearching = true);
      final results = await _searchPlacesUseCase(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
          _showResults = results.isNotEmpty;
        });
      }
    });
  }

  void _onPlaceSelected(SearchPlace place) {
    if (place.latitude == null || place.longitude == null) return;
    final latLng = LatLng(place.latitude!, place.longitude!);

    setState(() {
      _showResults = false;
      if (_isFromSearch) {
        _fromPlace = place;
        _fromLocation = latLng;
        _usingCurrentLocation = false;
        _fromSearchController.text = place.title;
        _fromSearchFocus.unfocus();
      } else {
        _selectedPlace = place;
        _toSearchController.text = place.title;
        _toSearchFocus.unfocus();
        if (!_showDirectionsPanel) {
          _routeInfo = null;
        }
      }
    });

    _mapController.move(latLng, 15);

    // Auto-calculate if both are set and in directions mode
    if (_showDirectionsPanel &&
        _fromLocation != null &&
        _selectedPlace != null) {
      _calculateRoute();
    }
  }

  // ── Current Location ────────────────────────────────────

  Future<void> _useCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Location permission permanently denied')),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      final latLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _fromLocation = latLng;
        _usingCurrentLocation = true;
        _fromPlace = null;
        _fromSearchController.text = 'My Location';
        _fromSearchFocus.unfocus();
        _showResults = false;
      });

      _mapController.move(latLng, 14);

      if (_showDirectionsPanel && _selectedPlace != null) {
        _calculateRoute();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    }
  }

  // ── Routing ─────────────────────────────────────────────

  Future<void> _calculateRoute() async {
    if (_fromLocation == null ||
        _selectedPlace?.latitude == null ||
        _selectedPlace?.longitude == null) return;
    setState(() => _isLoadingRoute = true);
    final route = await _getRouteUseCase(
      fromLat: _fromLocation!.latitude,
      fromLng: _fromLocation!.longitude,
      toLat: _selectedPlace!.latitude!,
      toLng: _selectedPlace!.longitude!,
    );
    if (mounted) {
      setState(() {
        _routeInfo = route;
        _isLoadingRoute = false;
      });
      if (route != null && route.polylinePoints.isNotEmpty) {
        final bounds = LatLngBounds.fromPoints(route.polylinePoints);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.fromLTRB(60, 200, 60, 100),
          ),
        );
      }
    }
  }

  void _openDirectionsPanel() {
    setState(() {
      _showDirectionsPanel = true;
      _showResults = false;
    });
  }

  // ── Clear Helpers ───────────────────────────────────────

  void _clearSelection() {
    setState(() {
      _selectedPlace = null;
      _routeInfo = null;
    });
  }

  void _clearSearch() {
    _toSearchController.clear();
    setState(() {
      _searchResults = [];
      _showResults = false;
      _selectedPlace = null;
      _routeInfo = null;
      _showDirectionsPanel = false;
    });
  }

  void _clearRoute() {
    setState(() {
      _routeInfo = null;
      _showDirectionsPanel = false;
      _fromLocation = null;
      _fromPlace = null;
      _usingCurrentLocation = false;
      _fromSearchController.clear();
    });
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (_showResults) setState(() => _showResults = false);
    _toSearchFocus.unfocus();
    _fromSearchFocus.unfocus();
  }

  // ── Build ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen Map ────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(20.5937, 78.9629),
              initialZoom: 5,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dbnus.app',
              ),
              // Route polyline
              if (_routeInfo != null &&
                  _routeInfo!.polylinePoints.isNotEmpty) ...[
                // Shadow polyline
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routeInfo!.polylinePoints,
                      strokeWidth: 8,
                      color: const Color(0xFF4285F4).withValues(alpha: 0.3),
                    ),
                  ],
                ),
                // Main polyline
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routeInfo!.polylinePoints,
                      strokeWidth: 5,
                      color: const Color(0xFF4285F4),
                    ),
                  ],
                ),
              ],
              MarkerLayer(
                markers: [
                  // Origin marker
                  if (_fromLocation != null)
                    Marker(
                      point: _fromLocation!,
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF34A853), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(FeatherIcons.circle,
                              color: Color(0xFF34A853), size: 14),
                        ),
                      ),
                    ),
                  // Selected / destination marker
                  if (_selectedPlace?.latitude != null &&
                      _selectedPlace?.longitude != null)
                    Marker(
                      point: LatLng(_selectedPlace!.latitude!,
                          _selectedPlace!.longitude!),
                      width: 40,
                      height: 50,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEA4335),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEA4335)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(FeatherIcons.mapPin,
                                color: Colors.white, size: 16),
                          ),
                          // Pin stem
                          Container(
                            width: 2,
                            height: 6,
                            color: const Color(0xFFEA4335),
                          ),
                        ],
                      ),
                    ),
                  // Destination on route
                  if (_routeInfo != null &&
                      _routeInfo!.polylinePoints.isNotEmpty)
                    Marker(
                      point: _routeInfo!.polylinePoints.last,
                      width: 40,
                      height: 50,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEA4335),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEA4335)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(FeatherIcons.mapPin,
                                color: Colors.white, size: 16),
                          ),
                          Container(
                            width: 2,
                            height: 6,
                            color: const Color(0xFFEA4335),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          // ── Top Search Panel ───────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _showDirectionsPanel
                      ? _buildDirectionsPanel()
                      : _buildSearchBar(),

                  // Search results dropdown
                  if (_showResults && _searchResults.isNotEmpty)
                    _buildSearchResults(),
                ],
              ),
            ),
          ),

          // ── Loading Route Indicator ────────────────────
          if (_isLoadingRoute)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      SizedBox(width: 10),
                      CustomText(
                        'Calculating route...',
                        color: Color(0xFF5F6368),
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Route Info Bar ─────────────────────────────
          if (_routeInfo != null &&
              _routeInfo!.polylinePoints.isNotEmpty &&
              !_isLoadingRoute)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RouteInfoBar(
                distanceKm: _routeInfo!.distanceKm,
                durationMinutes: _routeInfo!.durationMinutes,
                onClose: _clearRoute,
              ),
            ),

          // ── Place Details Card ─────────────────────────
          if (_selectedPlace != null &&
              !_showDirectionsPanel &&
              !_isLoadingRoute)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: PlaceDetailsCard(
                place: _selectedPlace!,
                onClose: _clearSelection,
                onDirections: _openDirectionsPanel,
              ),
            ),
        ],
      ),
    );
  }

  // ── Search Bar (Simple Mode) ──────────────────────────

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, size: 20),
              color: const Color(0xFF5F6368),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _toSearchController,
              focusNode: _toSearchFocus,
              onChanged: (q) => _onSearchChanged(q, isFrom: false),
              decoration: const InputDecoration(
                hintText: 'Search places...',
                hintStyle: TextStyle(color: Color(0xFF9AA0A6), fontSize: 15),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              ),
              style: const TextStyle(fontSize: 15, color: Color(0xFF202124)),
            ),
          ),
          if (_isSearching && !_isFromSearch)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Color(0xFF4285F4)),
              ),
            )
          else if (_toSearchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(FeatherIcons.x,
                  size: 18, color: Color(0xFF5F6368)),
              onPressed: _clearSearch,
            ),
        ],
      ),
    );
  }

  // ── Directions Panel (From + To) ──────────────────────

  Widget _buildDirectionsPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(FeatherIcons.arrowLeft, size: 20),
                  color: const Color(0xFF5F6368),
                  onPressed: _clearRoute,
                ),
                const Spacer(),
                const CustomText(
                  'Directions',
                  color: Color(0xFF202124),
                  fontWeight: FontWeight.w600,
                  size: 16,
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
          // From field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                // Green dot (origin)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF34A853),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                12.pw,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _fromSearchController,
                            focusNode: _fromSearchFocus,
                            onChanged: (q) => _onSearchChanged(q, isFrom: true),
                            decoration: const InputDecoration(
                              hintText: 'Choose starting point',
                              hintStyle: TextStyle(
                                  color: Color(0xFF9AA0A6), fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF202124)),
                          ),
                        ),
                        if (_isSearching && _isFromSearch)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Color(0xFF4285F4)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dots connecting from → to
          Padding(
            padding: const EdgeInsets.only(left: 21.5),
            child: Column(
              children: List.generate(
                3,
                (_) => Container(
                  width: 3,
                  height: 3,
                  margin: const EdgeInsets.symmetric(vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDADCE0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // To field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                // Red dot (destination)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA4335),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                12.pw,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _toSearchController,
                            focusNode: _toSearchFocus,
                            onChanged: (q) =>
                                _onSearchChanged(q, isFrom: false),
                            decoration: const InputDecoration(
                              hintText: 'Choose destination',
                              hintStyle: TextStyle(
                                  color: Color(0xFF9AA0A6), fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF202124)),
                          ),
                        ),
                        if (_isSearching && !_isFromSearch)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Color(0xFF4285F4)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.ph,
          // "Use my location" quick action
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: GestureDetector(
              onTap: _useCurrentLocation,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _usingCurrentLocation
                      ? const Color(0xFF4285F4).withValues(alpha: 0.1)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _usingCurrentLocation
                        ? const Color(0xFF4285F4).withValues(alpha: 0.3)
                        : const Color(0xFFE8EAED),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.crosshair,
                      size: 16,
                      color: _usingCurrentLocation
                          ? const Color(0xFF4285F4)
                          : const Color(0xFF5F6368),
                    ),
                    8.pw,
                    CustomText(
                      'Use my current location',
                      color: _usingCurrentLocation
                          ? const Color(0xFF4285F4)
                          : const Color(0xFF5F6368),
                      size: 13,
                      fontWeight: _usingCurrentLocation
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    if (_usingCurrentLocation) ...[
                      const Spacer(),
                      const Icon(FeatherIcons.check,
                          size: 16, color: Color(0xFF4285F4)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Results Dropdown ───────────────────────────

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 6),
          itemCount: _searchResults.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: Color(0xFFF1F3F4),
          ),
          itemBuilder: (context, index) {
            final place = _searchResults[index];
            return ListTile(
              dense: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(FeatherIcons.mapPin,
                    size: 16, color: Color(0xFF5F6368)),
              ),
              title: CustomText(
                place.title,
                color: const Color(0xFF202124),
                size: 14,
                fontWeight: FontWeight.w500,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: CustomText(
                place.shortAddress,
                color: const Color(0xFF9AA0A6),
                size: 12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => _onPlaceSelected(place),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            );
          },
        ),
      ),
    );
  }
}
