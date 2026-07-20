import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_js/three_js.dart' as three;
import '../../../../navigation/custom_router/custom_route.dart';
import '../../../../shared/ui/atoms/text/custom_text.dart';
import '../../../../shared/ui/atoms/buttons/custom_button.dart';

class CyberRunnerPage extends StatefulWidget {
  const CyberRunnerPage({super.key});

  @override
  State<CyberRunnerPage> createState() => _CyberRunnerPageState();
}

class _CyberRunnerPageState extends State<CyberRunnerPage> {
  late three.ThreeJS threeJs;

  // Game Parameters
  static const double tubeRadius = 9.5;
  static const double tubeLength = 300.0;
  static const double collisionDistance = 0.8;
  static const double baseSpeed = 70.0;

  double speedMultiplier = 1.0;
  int score = 0;
  int shield = 100;
  int highScore = 0;
  bool gameRunning = false;
  bool showGameOver = false;
  bool _initialized = false;
  String? _initError;

  double playerAngle = 0.0;
  bool keyLeft = false;
  bool keyRight = false;
  bool touchLeft = false;
  bool touchRight = false;

  // Scene Objects
  late three.Group playerGroup;
  late three.Mesh innerGridTube;
  late three.Points starfield;

  final List<three.Mesh> obstacles = [];
  final List<three.Mesh> collectibles = [];

  @override
  void initState() {
    super.initState();
    threeJs = three.ThreeJS(
      onSetupComplete: () {
        setState(() {});
      },
      setup: setup,
    );
  }

  @override
  void dispose() {
    threeJs.dispose();
    three.loading.clear();
    super.dispose();
  }

  Future<void> setup() async {
    try {
      // 1. Camera
      threeJs.camera = three.PerspectiveCamera(65, threeJs.width / threeJs.height, 0.1, 1000);
      threeJs.camera.position.setValues(0, 0, 8);
      threeJs.camera.lookAt(three.Vector3(0, 0, -20));

      // 2. Scene
      threeJs.scene = three.Scene();
      threeJs.scene.fog = three.FogExp2(0x05050e, 0.006);

      // 3. Lights
      final ambientLight = three.AmbientLight(0xffffff, 0.3);
      threeJs.scene.add(ambientLight);

      final dirLight = three.DirectionalLight(0xffffff, 0.4);
      dirLight.position.setValues(0, 5, 5);
      threeJs.scene.add(dirLight);

      final pointLight = three.PointLight(0x00f0ff, 1.5, 30);
      pointLight.position.setValues(0, 3, 2);
      threeJs.scene.add(pointLight);

      // 4. Tunnel
      final geomTube = three.CylinderGeometry(tubeRadius, tubeRadius, tubeLength, 24, 60, true);
      geomTube.rotateX(math.pi / 2);
      geomTube.translate(0, 0, -tubeLength / 2);

      final matOuter = three.MeshBasicMaterial.fromMap({
        'color': 0x050512,
        'side': three.BackSide,
        'transparent': true,
        'opacity': 0.95
      });
      final outerTube = three.Mesh(geomTube, matOuter);
      threeJs.scene.add(outerTube);

      final matGrid = three.MeshBasicMaterial.fromMap({
        'color': 0x00f0ff,
        'wireframe': true,
        'side': three.DoubleSide,
        'transparent': true,
        'opacity': 0.12
      });
      innerGridTube = three.Mesh(geomTube, matGrid);
      threeJs.scene.add(innerGridTube);

      // 5. Starfield
      const starCount = 1200;
      final starGeometry = three.BufferGeometry();
      final starPositions = Float32List(starCount * 3);
      final starSpeeds = Float32List(starCount);

      final random = math.Random();
      for (int i = 0; i < starCount; i++) {
        double angle = random.nextDouble() * math.pi * 2;
        double dist = tubeRadius + 2.0 + random.nextDouble() * 35.0;
        starPositions[i * 3] = math.cos(angle) * dist;
        starPositions[i * 3 + 1] = math.sin(angle) * dist;
        starPositions[i * 3 + 2] = -random.nextDouble() * 500.0;
        starSpeeds[i] = 1.0 + random.nextDouble() * 2.5;
      }

      starGeometry.setAttributeFromString('position', three.Float32BufferAttribute(starPositions, 3));
      final starMaterial = three.PointsMaterial.fromMap({
        'color': 0xffffff,
        'size': 0.25,
        'transparent': true,
        'opacity': 0.6
      });
      starfield = three.Points(starGeometry, starMaterial);
      starfield.userData = {'speeds': starSpeeds};
      threeJs.scene.add(starfield);

      // 6. Spaceship
      playerGroup = three.Group();

      // Cockpit
      final geomCockpit = three.ConeGeometry(0.3, 0.9, 4);
      geomCockpit.rotateX(math.pi / 2);
      final matCockpit = three.MeshPhongMaterial.fromMap({
        'color': 0xff007f,
        'emissive': 0x99004d,
        'shininess': 80,
        'flatShading': true
      });
      final cockpitMesh = three.Mesh(geomCockpit, matCockpit);
      playerGroup.add(cockpitMesh);

      // Wings
      final wingGeom = three.BoxGeometry(0.8, 0.06, 0.4);
      final matWing = three.MeshPhongMaterial.fromMap({
        'color': 0x00f0ff,
        'emissive': 0x0066aa,
        'flatShading': true
      });
      final leftWing = three.Mesh(wingGeom, matWing);
      leftWing.position.setValues(-0.4, -0.05, 0.15);
      leftWing.rotation.y = -0.1;
      leftWing.rotation.z = -0.15;
      playerGroup.add(leftWing);

      final rightWing = leftWing.clone();
      rightWing.position.x = 0.4;
      rightWing.rotation.z = 0.15;
      playerGroup.add(rightWing);

      // Flame
      final flameGeom = three.ConeGeometry(0.12, 0.5, 4);
      flameGeom.rotateX(-math.pi / 2);
      final matFlame = three.MeshBasicMaterial.fromMap({
        'color': 0xfff600,
        'transparent': true,
        'opacity': 0.8
      });
      final flameMesh = three.Mesh(flameGeom, matFlame);
      flameMesh.position.setValues(0, 0, 0.5);
      flameMesh.name = "engineFlame";
      playerGroup.add(flameMesh);

      threeJs.scene.add(playerGroup);
      updatePlayerPosition();

      // 7. Register Update Ticker Callback
      threeJs.addAnimationEvent(update);

      setState(() {
        _initialized = true;
        _initError = null;
      });
    } catch (e, stack) {
      debugPrint("ThreeJS Initialization Error: $e\n$stack");
      setState(() {
        _initError = e.toString();
      });
    }
  }

  void updatePlayerPosition() {
    const double rInner = tubeRadius - 0.5;
    playerGroup.position.x = math.cos(playerAngle) * rInner;
    playerGroup.position.y = math.sin(playerAngle) * rInner;
    playerGroup.position.z = 0;

    playerGroup.rotation.z = playerAngle - math.pi / 2;
    playerGroup.rotation.y = math.pi;
  }

  void startGame() {
    if (!_initialized) return;
    setState(() {
      score = 0;
      shield = 100;
      speedMultiplier = 1.0;
      playerAngle = 0.0;
      gameRunning = true;
      showGameOver = false;
    });

    for (var obs in obstacles) {
      threeJs.scene.remove(obs);
    }
    for (var col in collectibles) {
      threeJs.scene.remove(col);
    }
    obstacles.clear();
    collectibles.clear();
    updatePlayerPosition();
  }

  void gameOver() {
    setState(() {
      gameRunning = false;
      showGameOver = true;
      if (score > highScore) {
        highScore = score;
      }
    });
  }

  double spawnTimer = 0.0;

  void update(double dt) {
    if (!gameRunning) return;

    final random = math.Random();
    speedMultiplier += 0.015 * dt;

    // Controls
    final double rotSpeed = 3.5 * dt;
    if (keyLeft || touchLeft) playerAngle += rotSpeed;
    if (keyRight || touchRight) playerAngle -= rotSpeed;

    playerAngle = (playerAngle + math.pi * 2) % (math.pi * 2);
    updatePlayerPosition();

    // Rotate Tube Grid
    innerGridTube.rotation.z += 0.08 * dt;

    // Banking Camera
    threeJs.camera.position.x = threeJs.camera.position.x + (playerGroup.position.x * 0.12 - threeJs.camera.position.x) * 0.1;
    threeJs.camera.position.y = threeJs.camera.position.y + (playerGroup.position.y * 0.12 - threeJs.camera.position.y) * 0.1;
    threeJs.camera.lookAt(three.Vector3(playerGroup.position.x * 0.3, playerGroup.position.y * 0.3, -25));

    // engineFlame pulse scale
    final flame = playerGroup.getObjectByName("engineFlame");
    if (flame != null) {
      flame.scale.y = 0.8 + math.sin(DateTime.now().millisecondsSinceEpoch * 0.05) * 0.3;
      flame.scale.x = 0.9 + math.cos(DateTime.now().millisecondsSinceEpoch * 0.05) * 0.1;
    }

    // Spawning timer
    spawnTimer += dt;
    final double spawnInterval = 0.8 / speedMultiplier;
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0.0;
      spawnEntity();
    }

    final currentSpeed = baseSpeed * speedMultiplier;

    // Update Obstacles
    for (int i = obstacles.length - 1; i >= 0; i--) {
      final obs = obstacles[i];
      obs.position.z += currentSpeed * dt;

      if (obs.position.z.abs() < collisionDistance) {
        final double obsAngle = obs.userData['angle'];
        final double angleDiff = (playerAngle - obsAngle).abs();
        final double minDiff = math.min(angleDiff, math.pi * 2 - angleDiff);
        if (minDiff < 0.22) {
          threeJs.scene.remove(obs);
          obstacles.removeAt(i);
          shield -= 25;
          if (shield <= 0) {
            shield = 0;
            gameOver();
          }
          setState(() {});
          continue;
        }
      }

      if (obs.position.z > 12) {
        threeJs.scene.remove(obs);
        obstacles.removeAt(i);
        score += (10 * speedMultiplier).round();
        setState(() {});
      }
    }

    // Update Collectibles
    for (int i = collectibles.length - 1; i >= 0; i--) {
      final col = collectibles[i];
      col.position.z += currentSpeed * dt;
      col.rotation.y += 3.0 * dt;
      col.rotation.x += 1.5 * dt;

      if (col.position.z.abs() < collisionDistance) {
        final double colAngle = col.userData['angle'];
        final double angleDiff = (playerAngle - colAngle).abs();
        final double minDiff = math.min(angleDiff, math.pi * 2 - angleDiff);
        if (minDiff < 0.25) {
          final bool isRepair = col.userData['type'] == 1;
          if (isRepair) {
            shield = math.min(shield + 20, 100);
          } else {
            score += (50 * speedMultiplier).round();
          }
          threeJs.scene.remove(col);
          collectibles.removeAt(i);
          setState(() {});
          continue;
        }
      }

      if (col.position.z > 12) {
        threeJs.scene.remove(col);
        collectibles.removeAt(i);
      }
    }

    // Update Starfield position array
    final positionAttr = starfield.geometry!.getAttributeFromString('position');
    if (positionAttr != null) {
      final positions = positionAttr.array;
      final speeds = starfield.userData['speeds'];
      final flowSpeed = currentSpeed * 0.15;
      for (int i = 0; i < speeds.length; i++) {
        positions[i * 3 + 2] += (speeds[i] * flowSpeed) * dt;
        if (positions[i * 3 + 2] > 20) {
          positions[i * 3 + 2] = -350 - random.nextDouble() * 150;
        }
      }
      positionAttr.needsUpdate = true;
    }
  }

  void spawnEntity() {
    final random = math.Random();
    double angle = random.nextDouble() * math.pi * 2;
    const double distance = tubeRadius - 0.7;
    const double spawnZ = -tubeLength;

    double roll = random.nextDouble();
    if (roll < 0.65) {
      // Spawn obstacle (Red neon cube)
      final size = 1.2 + random.nextDouble() * 0.8;
      final geom = three.BoxGeometry(size, 0.8, size);
      final mat = three.MeshPhongMaterial.fromMap({
        'color': 0xff003c,
        'emissive': 0x880011,
        'flatShading': true,
        'shininess': 30
      });
      final obs = three.Mesh(geom, mat);
      obs.position.setValues(math.cos(angle) * distance, math.sin(angle) * distance, spawnZ);
      obs.rotation.set(random.nextDouble(), random.nextDouble(), angle);
      obs.userData = {'angle': angle};
      threeJs.scene.add(obs);
      obstacles.add(obs);
    } else if (roll < 0.9) {
      // Spawn score crystal (Cyan Octahedron)
      final geom = three.OctahedronGeometry(0.35, 0);
      final mat = three.MeshPhongMaterial.fromMap({
        'color': 0x00ffcc,
        'emissive': 0x006655,
        'shininess': 90
      });
      final cry = three.Mesh(geom, mat);
      cry.position.setValues(math.cos(angle) * distance, math.sin(angle) * distance, spawnZ);
      cry.userData = {'angle': angle, 'type': 0};
      threeJs.scene.add(cry);
      collectibles.add(cry);
    } else {
      // Spawn repair sphere (Gold Dodecahedron)
      final geom = three.DodecahedronGeometry(0.3, 0);
      final mat = three.MeshPhongMaterial.fromMap({
        'color': 0xffd700,
        'emissive': 0x887700,
        'shininess': 90
      });
      final rep = three.Mesh(geom, mat);
      rep.position.setValues(math.cos(angle) * distance, math.sin(angle) * distance, spawnZ);
      rep.userData = {'angle': angle, 'type': 1};
      threeJs.scene.add(rep);
      collectibles.add(rep);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        final isDown = event is KeyDownEvent || event is KeyRepeatEvent;
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) {
          keyLeft = isDown;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) {
          keyRight = isDown;
        }
        if (event.logicalKey == LogicalKeyboardKey.space && !gameRunning && !showGameOver) {
          startGame();
        }
        return KeyEventResult.handled;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF05050e),
        body: Stack(
          children: [
            // 3D Viewport
            Positioned.fill(
              child: threeJs.build(),
            ),

            if (!_initialized)
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF05050e),
                  child: Center(
                    child: _initError != null
                        ? Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, color: Color(0xFFFF007F), size: 48),
                                const SizedBox(height: 16),
                                CustomText('Engine Error: $_initError', color: Colors.white, size: 14, textAlign: TextAlign.center),
                                const SizedBox(height: 24),
                                CustomGOEButton(
                                  onPressed: () {
                                    setState(() {
                                      _initError = null;
                                      _initialized = false;
                                    });
                                    setup();
                                  },
                                  backGroundColor: const Color(0xFFFF007F),
                                  child: const CustomText('Retry', color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F0FF)),
                              ),
                              SizedBox(height: 16),
                              CustomText('Initializing 3D Engines...', color: Color(0xFF8B8BA7), size: 14, fontWeight: FontWeight.bold),
                            ],
                          ),
                  ),
                ),
              ),

            // Top HUD Overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button & Score
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                            onPressed: () => CustomRoute.back(),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0x990a0a19),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0x3300f0ff)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText('SCORE', color: Color(0xFF00F0FF), size: 10, fontWeight: FontWeight.bold),
                                CustomText('$score', color: Colors.white, size: 20, fontWeight: FontWeight.w900),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Shield & Multiplier
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0x990a0a19),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0x33ff007f)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const CustomText('SHIELDS', color: Color(0xFFFF007F), size: 10, fontWeight: FontWeight.bold),
                                const SizedBox(height: 4),
                                Container(
                                  width: 120,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 120 * (shield / 100),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [Color(0xFFFF007F), Color(0xFFFF00FF)]),
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF007F).withValues(alpha: 0.8),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomText('x${speedMultiplier.toStringAsFixed(1)}', color: const Color(0xFFFF007F), size: 14, fontWeight: FontWeight.bold),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Touch Control Zones (Transparent left/right overlay)
            if (gameRunning)
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: Listener(
                        onPointerDown: (_) => touchLeft = true,
                        onPointerUp: (_) => touchLeft = false,
                        onPointerCancel: (_) => touchLeft = false,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Expanded(
                      child: Listener(
                        onPointerDown: (_) => touchRight = true,
                        onPointerUp: (_) => touchRight = false,
                        onPointerCancel: (_) => touchRight = false,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),

            // Start Screen Overlay
            if (!gameRunning && !showGameOver)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.8),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(32),
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: const Color(0xDD0f0f23),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0x6600f0ff), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x3300f0ff),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomText('Cyber Tube 3D', color: Colors.white, size: 28, fontWeight: FontWeight.w900),
                          const SizedBox(height: 8),
                          const CustomText('Neon 3D Tunnel Runner', color: Color(0xFF8B8BA7), size: 14, fontWeight: FontWeight.bold),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText('🚀 Dodge neon obstacles', color: Color(0xFFA4A4C1), size: 12),
                                SizedBox(height: 6),
                                CustomText('💎 Collect cyan crystals for points', color: Color(0xFFA4A4C1), size: 12),
                                SizedBox(height: 6),
                                CustomText('🛠️ Collect golden spheres to repair shields', color: Color(0xFFA4A4C1), size: 12),
                                SizedBox(height: 12),
                                CustomText('Controls:', color: Color(0xFF00F0FF), size: 12, fontWeight: FontWeight.bold),
                                SizedBox(height: 4),
                                CustomText('💻 PC: LEFT/RIGHT Arrows or A/D', color: Color(0xFFA4A4C1), size: 12),
                                SizedBox(height: 4),
                                CustomText('📱 Mobile: Tap and hold sides of screen', color: Color(0xFFA4A4C1), size: 12),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomGOEButton(
                            onPressed: startGame,
                            backGroundColor: const Color(0xFF00F0FF),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            borderRadius: BorderRadius.circular(14),
                            child: const CustomText('Launch Ship', color: Colors.black, fontWeight: FontWeight.bold, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Game Over Screen Overlay
            if (showGameOver)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.85),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(32),
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: const Color(0xDD0f0f23),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0x66ff007f), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x33ff007f),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomText('Ship Terminated', color: Color(0xFFFF007F), size: 28, fontWeight: FontWeight.w900),
                          const SizedBox(height: 8),
                          const CustomText('Vessel Destroyed', color: Color(0xFF8B8BA7), size: 14, fontWeight: FontWeight.bold),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText('Final Score:', color: Color(0xFFA4A4C1), size: 16),
                              CustomText('$score', color: const Color(0xFFFF007F), size: 18, fontWeight: FontWeight.bold),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText('High Score:', color: Color(0xFFA4A4C1), size: 16),
                              CustomText('$highScore', color: const Color(0xFF00F0FF), size: 18, fontWeight: FontWeight.bold),
                            ],
                          ),
                          const SizedBox(height: 28),
                          CustomGOEButton(
                            onPressed: startGame,
                            backGroundColor: const Color(0xFFFF007F),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            borderRadius: BorderRadius.circular(14),
                            child: const CustomText('Respawn Ship', color: Colors.white, fontWeight: FontWeight.bold, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
