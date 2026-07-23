import 'dart:math' as math;
import 'package:three_js/three_js.dart' as three;

three.Object3D createSpaceshipGlbFallback() {
  final group = three.Group();

  // Main aerodynamic fuselage
  final geomBody = three.CylinderGeometry(0.18, 0.36, 1.7, 8);
  geomBody.rotateX(math.pi / 2);
  final matBody = three.MeshPhongMaterial.fromMap({
    'color': 0x16172b,
    'emissive': 0x050615,
    'shininess': 60,
    'flatShading': true
  });
  final bodyMesh = three.Mesh(geomBody, matBody);
  group.add(bodyMesh);

  // Sleek cockpit canopy (translucent cyan)
  final geomCockpit = three.ConeGeometry(0.24, 0.85, 6);
  geomCockpit.rotateX(math.pi / 2);
  geomCockpit.translate(0, 0.12, -0.22);
  final matCockpit = three.MeshPhongMaterial.fromMap({
    'color': 0x00f0ff,
    'emissive': 0x004466,
    'transparent': true,
    'opacity': 0.8,
    'shininess': 100
  });
  final cockpitMesh = three.Mesh(geomCockpit, matCockpit);
  group.add(cockpitMesh);

  // Left Swept Wing
  final geomWingL = three.BoxGeometry(1.3, 0.06, 0.65);
  geomWingL.translate(-0.72, -0.05, 0.15);
  geomWingL.rotateY(-0.16);
  geomWingL.rotateZ(-0.08);
  final matWing = three.MeshPhongMaterial.fromMap({
    'color': 0x00f0ff,
    'emissive': 0x003344,
    'shininess': 60,
    'flatShading': true
  });
  final wingL = three.Mesh(geomWingL, matWing);
  group.add(wingL);

  // Right Swept Wing
  final geomWingR = three.BoxGeometry(1.3, 0.06, 0.65);
  geomWingR.translate(0.72, -0.05, 0.15);
  geomWingR.rotateY(0.16);
  geomWingR.rotateZ(0.08);
  final wingR = three.Mesh(geomWingR, matWing);
  group.add(wingR);

  // Dual wingtip laser cannons
  final geomCannon = three.CylinderGeometry(0.035, 0.035, 0.45, 6);
  geomCannon.rotateX(math.pi / 2);
  final matCannon = three.MeshPhongMaterial.fromMap({
    'color': 0xff0055,
    'emissive': 0x440011,
    'shininess': 80
  });

  final cannonL = three.Mesh(geomCannon, matCannon);
  cannonL.position.setValues(-1.35, -0.1, 0.1);
  group.add(cannonL);

  final cannonR = three.Mesh(geomCannon, matCannon);
  cannonR.position.setValues(1.35, -0.1, 0.1);
  group.add(cannonR);

  // Plasma Engine Flame
  final geomFlame = three.ConeGeometry(0.2, 0.8, 6);
  geomFlame.rotateX(-math.pi / 2);
  final matFlame = three.MeshBasicMaterial.fromMap({
    'color': 0x00ffff,
    'transparent': true,
    'opacity': 0.85
  });
  final flameMesh = three.Mesh(geomFlame, matFlame);
  flameMesh.position.setValues(0, 0, 0.92);
  flameMesh.name = "engineFlame";
  group.add(flameMesh);

  return group;
}
