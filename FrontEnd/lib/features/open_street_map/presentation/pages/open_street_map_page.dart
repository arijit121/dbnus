import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/features/open_street_map/data/models/map_marker_model.dart';
import 'package:dbnus/features/open_street_map/domain/entities/map_marker.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/map_header.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/map_marker_info.dart';

class OpenStreetMapPage extends StatefulWidget {
  const OpenStreetMapPage({super.key});

  @override
  State<OpenStreetMapPage> createState() => _OpenStreetMapPageState();
}

class _OpenStreetMapPageState extends State<OpenStreetMapPage> {
  final MapController _mapController = MapController();
  MapMarker? _selectedMarker;
  final List<MapMarkerModel> _markers = MapMarkerModel.sampleMarkers;

  void _onMarkerTap(MapMarker marker) {
    setState(() {
      _selectedMarker = marker;
    });
    _mapController.move(marker.position, 6);
  }

  void _clearSelection() {
    setState(() {
      _selectedMarker = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: MapHeader(),
              ),
              12.ph,
              // Marker chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _markers.length,
                  separatorBuilder: (_, __) => 8.pw,
                  itemBuilder: (context, index) {
                    final marker = _markers[index];
                    final isSelected = _selectedMarker?.name == marker.name;
                    return GestureDetector(
                      onTap: () => _onMarkerTap(marker),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? marker.color
                              : marker.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: marker.color
                                .withValues(alpha: isSelected ? 1 : 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(marker.icon,
                                color: isSelected ? Colors.white : marker.color,
                                size: 16),
                            6.pw,
                            CustomText(
                              marker.name,
                              color: isSelected ? Colors.white : marker.color,
                              fontWeight: FontWeight.w600,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              12.ph,
              // Map
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(20, 0),
                        initialZoom: 2.5,
                        onTap: (_, __) => _clearSelection(),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.dbnus.app',
                        ),
                        MarkerLayer(
                          markers: _markers.map((marker) {
                            final isSelected =
                                _selectedMarker?.name == marker.name;
                            return Marker(
                              point: marker.position,
                              width: isSelected ? 50 : 40,
                              height: isSelected ? 50 : 40,
                              child: GestureDetector(
                                onTap: () => _onMarkerTap(marker),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? marker.color
                                        : marker.color.withValues(alpha: 0.85),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            marker.color.withValues(alpha: 0.5),
                                        blurRadius: isSelected ? 12 : 6,
                                        spreadRadius: isSelected ? 2 : 0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.white,
                                      width: isSelected ? 3 : 2,
                                    ),
                                  ),
                                  child: Icon(
                                    marker.icon,
                                    color: Colors.white,
                                    size: isSelected ? 22 : 18,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        // Attribution
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution(
                              'OpenStreetMap contributors',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              16.ph,
            ],
          ),
          // Marker info card overlay
          if (_selectedMarker != null)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: MapMarkerInfo(
                marker: _selectedMarker!,
                onClose: _clearSelection,
              ),
            ),
        ],
      ),
    );
  }
}
