import 'dart:async';

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
import 'package:dbnus/features/open_street_map/presentation/pages/navigation_page.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/directions_panel.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/route_info_bar.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/search_results_dropdown.dart';

/// Page for planning a route: choosing origin/destination and viewing the route.
/// Accepts an optional [destination] to pre-fill the "To" field.
class RoutePlannerPage extends StatefulWidget {
  final SearchPlace? destination;

  const RoutePlannerPage({super.key, this.destination});

  @override
  State<RoutePlannerPage> createState() => _RoutePlannerPageState();
}

class _RoutePlannerPageState extends State<RoutePlannerPage> {
  final MapController _mapController = MapController();
  final TextEditingController _fromSearchController = TextEditingController();
  final TextEditingController _toSearchController = TextEditingController();
  final FocusNode _fromSearchFocus = FocusNode();
  final FocusNode _toSearchFocus = FocusNode();

  late final SearchPlacesUseCase _searchPlacesUseCase;
  late final GetRouteUseCase _getRouteUseCase;

  // State
  List<SearchPlace> _searchResults = [];
  LatLng? _fromLocation;
  SearchPlace? _selectedPlace;
  RouteInfo? _routeInfo;
  bool _isSearching = false;
  bool _isLoadingRoute = false;
  bool _isLoadingLocation = false;
  bool _showResults = false;
  bool _isFromSearch = false;
  bool _usingCurrentLocation = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final ds = MapRemoteDataSourceImpl();
    final repo = MapRepositoryImpl(remoteDataSource: ds);
    _searchPlacesUseCase = SearchPlacesUseCase(repo);
    _getRouteUseCase = GetRouteUseCase(repo);

    if (widget.destination != null) {
      _selectedPlace = widget.destination;
      _toSearchController.text = widget.destination!.title;
    }
  }

  @override
  void dispose() {
    _fromSearchController.dispose();
    _toSearchController.dispose();
    _fromSearchFocus.dispose();
    _toSearchFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Search Logic ──────────────────────────────────────

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
        _fromLocation = latLng;
        _usingCurrentLocation = false;
        _fromSearchController.text = place.title;
        _fromSearchFocus.unfocus();
      } else {
        _selectedPlace = place;
        _toSearchController.text = place.title;
        _toSearchFocus.unfocus();
      }
    });

    _mapController.move(latLng, 15);

    if (_fromLocation != null && _selectedPlace != null) {
      _calculateRoute();
    }
  }

  // ── Current Location ──────────────────────────────────

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
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
          setState(() => _isLoadingLocation = false);
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
        setState(() => _isLoadingLocation = false);
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
        _isLoadingLocation = false;
        _fromSearchController.text = 'My Location';
        _fromSearchFocus.unfocus();
        _showResults = false;
      });
      _mapController.move(latLng, 14);
      if (_selectedPlace != null) _calculateRoute();
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    }
  }

  // ── Routing ───────────────────────────────────────────

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
            padding: const EdgeInsets.fromLTRB(60, 200, 60, 120),
          ),
        );
      }
    }
  }

  void _startNavigation() {
    if (_routeInfo == null || _routeInfo!.polylinePoints.length < 2) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NavigationPage(routeInfo: _routeInfo!),
      ),
    );
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (_showResults) setState(() => _showResults = false);
    _toSearchFocus.unfocus();
    _fromSearchFocus.unfocus();
  }

  // ── Light Blue Tile Tint ────────────────────────────────

  Widget _lightBlueTileBuilder(
      BuildContext context, Widget tileWidget, TileImage tile) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.9, 0, 0, 0, 10, // R: slightly muted
        0, 0.92, 0, 0, 15, // G: slightly muted
        0, 0, 1.0, 0, 25, // B: slight blue boost
        0, 0, 0, 1, 0, // A: keep alpha
      ]),
      child: tileWidget,
    );
  }

  // ── Build ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedPlace?.latitude != null
                  ? LatLng(
                      _selectedPlace!.latitude!, _selectedPlace!.longitude!)
                  : const LatLng(20.5937, 78.9629),
              initialZoom: _selectedPlace != null ? 13 : 5,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dbnus.app',
                tileBuilder: _lightBlueTileBuilder,
              ),
              // Route polyline
              if (_routeInfo != null &&
                  _routeInfo!.polylinePoints.isNotEmpty) ...[
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routeInfo!.polylinePoints,
                      strokeWidth: 8,
                      color: const Color(0xFF4285F4).withValues(alpha: 0.25),
                    ),
                  ],
                ),
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
                  // Destination marker
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

          // Directions Panel
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DirectionsPanel(
                    fromController: _fromSearchController,
                    toController: _toSearchController,
                    fromFocusNode: _fromSearchFocus,
                    toFocusNode: _toSearchFocus,
                    isSearching: _isSearching,
                    isFromSearch: _isFromSearch,
                    usingCurrentLocation: _usingCurrentLocation,
                    loadingLocation: _isLoadingLocation,
                    onFromChanged: (q) => _onSearchChanged(q, isFrom: true),
                    onToChanged: (q) => _onSearchChanged(q, isFrom: false),
                    onClearRoute: () => Navigator.pop(context),
                    onUseCurrentLocation: _useCurrentLocation,
                  ),
                  if (_showResults && _searchResults.isNotEmpty)
                    SearchResultsDropdown(
                      results: _searchResults,
                      onPlaceSelected: _onPlaceSelected,
                    ),
                ],
              ),
            ),
          ),

          // Loading Indicator
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

          // Route Info Bar
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
                onClose: () => Navigator.pop(context),
                onStartNavigation: _startNavigation,
                routeSummary: _routeInfo!.summary,
              ),
            ),
        ],
      ),
    );
  }
}
