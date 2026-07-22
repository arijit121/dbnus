import 'package:flutter/material.dart';
import '../../domain/entities/glb_model_entity.dart';

class GlbModel extends GlbModelEntity {
  const GlbModel({
    required super.id,
    required super.name,
    required super.description,
    required super.assetPath,
    required super.defaultScale,
    required super.themeColor,
  });

  static const List<GlbModel> presetModels = [
    GlbModel(
      id: 'damaged_helmet',
      name: 'Cyber Helmet',
      description: 'Futuristic Sci-Fi Battle Helmet with PBR textures',
      assetPath: 'assets/models/damaged_helmet.glb',
      defaultScale: 1.8,
      themeColor: Color(0xFFFF0055),
    ),
    GlbModel(
      id: 'duck',
      name: 'Golden Duck',
      description: 'Classic Khronos 3D Duck GLB Model',
      assetPath: 'assets/models/duck.glb',
      defaultScale: 1.4,
      themeColor: Color(0xFFFFCC00),
    ),
    GlbModel(
      id: 'cesium_man',
      name: 'Astronaut Explorer',
      description: 'Rigged 3D Character Model',
      assetPath: 'assets/models/cesium_man.glb',
      defaultScale: 2.0,
      themeColor: Color(0xFF00F0FF),
    ),
    GlbModel(
      id: 'avocado',
      name: '3D Avocado',
      description: 'Photogrammetry 3D Model',
      assetPath: 'assets/models/avocado.glb',
      defaultScale: 15.0,
      themeColor: Color(0xFF00FF66),
    ),
  ];
}
