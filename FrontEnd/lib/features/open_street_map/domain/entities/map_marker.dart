import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  final String name;
  final String description;
  final LatLng position;
  final IconData icon;
  final Color color;

  const MapMarker({
    required this.name,
    required this.description,
    required this.position,
    required this.icon,
    required this.color,
  });
}
