import 'dart:async';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:dbnus/features/open_street_map/data/datasources/map_remote_data_source.dart';
import 'package:dbnus/features/open_street_map/data/repositories/map_repository_impl.dart';
import 'package:dbnus/features/open_street_map/domain/entities/search_place.dart';
import 'package:dbnus/features/open_street_map/domain/usecases/search_places_usecase.dart';
import 'package:dbnus/features/open_street_map/presentation/pages/route_planner_page.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/map_search_bar.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/place_details_card.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/search_results_dropdown.dart';

/// Main map explorer page: search places, view details, then navigate.
class OpenStreetMapPage extends StatefulWidget {
  const OpenStreetMapPage({super.key});

  @override
  State<OpenStreetMapPage> createState() => _OpenStreetMapPageState();
}

class _OpenStreetMapPageState extends State<OpenStreetMapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  late final SearchPlacesUseCase _searchPlacesUseCase;

  // State
  List<SearchPlace> _searchResults = [];
  SearchPlace? _selectedPlace;
  bool _isSearching = false;
  bool _showResults = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final ds = MapRemoteDataSourceImpl();
    final repo = MapRepositoryImpl(remoteDataSource: ds);
    _searchPlacesUseCase = SearchPlacesUseCase(repo);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Search Logic ──────────────────────────────────────

  void _onSearchChanged(String query) {
    _debounce?.cancel();
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
      _selectedPlace = place;
      _searchController.text = place.title;
      _showResults = false;
      _searchFocus.unfocus();
    });
    _mapController.move(latLng, 15);
  }

  void _clearSelection() {
    setState(() => _selectedPlace = null);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _showResults = false;
      _selectedPlace = null;
    });
  }

  void _openDirections() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutePlannerPage(destination: _selectedPlace),
      ),
    );
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (_showResults) setState(() => _showResults = false);
    _searchFocus.unfocus();
  }

  // ── Build ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(20.5937, 78.9629),
              initialZoom: 5,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dbnus.app',
              ),
              MarkerLayer(
                markers: [
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

          // Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MapSearchBar(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    isSearching: _isSearching,
                    onChanged: _onSearchChanged,
                    onClear: _clearSearch,
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

          // Place Details Card
          if (_selectedPlace != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: PlaceDetailsCard(
                place: _selectedPlace!,
                onClose: _clearSelection,
                onDirections: _openDirections,
              ),
            ),

          // Loading indicator placeholder
          if (_isSearching)
            const Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF4285F4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
