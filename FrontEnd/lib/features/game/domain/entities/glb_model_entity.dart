import 'package:flutter/material.dart';

class GlbModelEntity {
  final String id;
  final String name;
  final String description;
  final String assetPath;
  final double defaultScale;
  final Color themeColor;

  const GlbModelEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.assetPath,
    required this.defaultScale,
    required this.themeColor,
  });
}
