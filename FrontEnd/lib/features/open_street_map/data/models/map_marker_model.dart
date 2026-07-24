import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/map_marker.dart';

class MapMarkerModel extends MapMarker {
  const MapMarkerModel({
    required super.name,
    required super.description,
    required super.position,
    required super.icon,
    required super.color,
  });

  static List<MapMarkerModel> sampleMarkers = [
    MapMarkerModel(
      name: 'Eiffel Tower',
      description: 'Iconic iron lattice tower in Paris, France.',
      position: const LatLng(48.8584, 2.2945),
      icon: Icons.location_city_rounded,
      color: const Color(0xFF6C63FF),
    ),
    MapMarkerModel(
      name: 'Statue of Liberty',
      description: 'Colossal neoclassical sculpture in New York Harbor.',
      position: const LatLng(40.6892, -74.0445),
      icon: Icons.emoji_people_rounded,
      color: const Color(0xFF4ECDC4),
    ),
    MapMarkerModel(
      name: 'Taj Mahal',
      description: 'Ivory-white marble mausoleum in Agra, India.',
      position: const LatLng(27.1751, 78.0421),
      icon: Icons.temple_hindu_rounded,
      color: const Color(0xFFFF6B6B),
    ),
    MapMarkerModel(
      name: 'Great Wall of China',
      description: 'Ancient series of walls and fortifications.',
      position: const LatLng(40.4319, 116.5704),
      icon: Icons.landscape_rounded,
      color: const Color(0xFFE67E22),
    ),
    MapMarkerModel(
      name: 'Colosseum',
      description: 'Ancient amphitheatre in the centre of Rome, Italy.',
      position: const LatLng(41.8902, 12.4922),
      icon: Icons.stadium_rounded,
      color: const Color(0xFF8E44AD),
    ),
    MapMarkerModel(
      name: 'Sydney Opera House',
      description: 'Multi-venue performing arts centre in Sydney, Australia.',
      position: const LatLng(-33.8568, 151.2153),
      icon: Icons.music_note_rounded,
      color: const Color(0xFF2980B9),
    ),
  ];
}
