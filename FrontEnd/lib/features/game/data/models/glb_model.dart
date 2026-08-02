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
}
