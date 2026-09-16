import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/shared/constants/assects_const.dart';

class GevContactModelPreview extends StatefulWidget {
  final GeointContact contact;
  final Color hudColor;

  const GevContactModelPreview({
    super.key,
    required this.contact,
    required this.hudColor,
  });

  @override
  State<GevContactModelPreview> createState() => _GevContactModelPreviewState();
}

class _GevContactModelPreviewState extends State<GevContactModelPreview> {
  late final three.ThreeJS threeJs;
  three.Object3D? _model;
  bool _isReady = false;
  bool _hasError = false;

  String? get _assetPath {
    final contact = widget.contact;
    if (contact is VesselContact) return AssetsConst.shipGlbModel;
    if (contact is! FlightContact) return null;
    if (contact.isMilitary) return AssetsConst.mq9GlbModel;
    if (contact.model.contains('787')) return AssetsConst.b789GlbModel;
    return AssetsConst.airplaneGlbModel;
  }

  @override
  void initState() {
    super.initState();
    threeJs = three.ThreeJS(
      onSetupComplete: () {
        if (mounted) setState(() => _isReady = true);
      },
      setup: _setup,
    );
  }

  @override
  void dispose() {
    threeJs.dispose();
    three.loading.clear();
    super.dispose();
  }

  Future<void> _setup() async {
    try {
      threeJs.camera = three.PerspectiveCamera(
        42,
        threeJs.width / threeJs.height,
        0.1,
        100,
      );
      threeJs.camera.position.setValues(0, 1.1, 5.8);
      threeJs.camera.lookAt(three.Vector3(0, 0, 0));
      threeJs.scene = three.Scene();
      threeJs.scene.fog = three.FogExp2(0x050B10, 0.035);
      threeJs.scene.add(three.AmbientLight(0xffffff, 1.1));

      final keyLight = three.DirectionalLight(0xBDEEFF, 1.5);
      keyLight.position.setValues(3, 4, 5);
      threeJs.scene.add(keyLight);

      final assetPath = _assetPath;
      if (assetPath == null) return;
      final gltf = await three.GLTFLoader().fromAsset(assetPath);
      final model = gltf?.scene;
      if (model == null) return;
      model.scale.setValues(1.35, 1.35, 1.35);
      model.rotation.y = math.pi / 2;
      _model = model;
      threeJs.scene.add(model);
      threeJs.addAnimationEvent(_rotateModel);
    } catch (_) {
      _hasError = true;
    }
  }

  void _rotateModel([double? _]) {
    _model?.rotation.y += 0.004;
  }

  @override
  Widget build(BuildContext context) {
    final modelName = widget.contact is VesselContact
        ? 'SHIP MODEL // GLB'
        : widget.contact is FlightContact
            ? 'AIRCRAFT MODEL // GLB'
            : '';

    return Container(
      height: 112,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF03070D).withValues(alpha: 0.9),
        border: Border.all(color: widget.hudColor.withValues(alpha: 0.28)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_isReady && !_hasError)
            threeJs.build()
          else
            Center(
              child: Text(
                _hasError ? 'MODEL FEED UNAVAILABLE' : 'LOADING MODEL FEED...',
                style: TextStyle(
                  color: widget.hudColor.withValues(alpha: 0.55),
                  fontSize: 8,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              ),
            ),
          Positioned(
            top: 6,
            left: 8,
            child: Text(
              modelName,
              style: TextStyle(
                color: widget.hudColor.withValues(alpha: 0.75),
                fontSize: 8,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
