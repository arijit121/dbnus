import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_js/three_js.dart' as three;
import '../../../../core/services/JsService/provider/js_provider.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/ui/atoms/indicators/loading_widget.dart';
import '../../../../shared/ui/atoms/text/custom_text.dart';
import '../../data/models/glb_model.dart';
import '../bloc/glb_model_game_bloc.dart';
import '../utils/glb_spaceship_builder.dart';
import '../widget/glb_model_game/glb_game_controls.dart';
import '../widget/glb_model_game/glb_game_hud.dart';
import '../widget/glb_model_game/glb_game_overlays.dart';
import '../widget/glb_model_game/radar_painter.dart';

class GlbModelGamePage extends StatelessWidget {
  const GlbModelGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GlbModelGameBloc(),
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: JsProvider.loadJs(
              jsPath:
                  "https://cdn.jsdelivr.net/gh/Knightro63/flutter_angle/assets/gles_bindings.js",
            ),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.done) {
                return const GlbModelGameData();
              } else if (asyncSnapshot.hasError) {
                return Center(
                  child: CustomText('Error loading JS: ${asyncSnapshot.error}'),
                );
              } else {
                return const Center(
                  child: LoadingWidget(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class GlbModelGameData extends StatefulWidget {
  const GlbModelGameData({super.key});

  @override
  State<GlbModelGameData> createState() => _GlbModelGameDataState();
}

class _GlbModelGameDataState extends State<GlbModelGameData> {
  late three.ThreeJS threeJs;

  // Game configuration constants
  static const double baseShipSpeed = 80.0;
  static const double collisionZThreshold = 1.2;

  // Single Spaceship GLB Metadata
  static const spaceshipModel = GlbModel(
    id: 'spaceship',
    name: 'Sci-Fi Interceptor',
    description: 'Futuristic Sci-Fi Battle Cruiser GLB Model',
    assetPath: AssetsConst.spaceshipGlbModel,
    defaultScale: 1.5,
    themeColor: Color(0xFF00F0FF),
  );

  // Game loop mechanical state
  double speedMultiplier = 1.0;
  double playerX = 0.0;
  double playerY = 0.0;
  bool keyLeft = false;
  bool keyRight = false;
  bool keyUp = false;
  bool keyDown = false;
  bool keySpace = false;

  // Space weapons heat management
  double laserHeat = 0.0;
  bool laserOverheated = false;
  double shootCooldown = 0.0;

  // Screen shake effect for collisions
  double cameraShakeIntensity = 0.0;

  // Scene elements
  late three.Group playerGroup;
  late three.Points starfield;
  three.Object3D? currentGlbMesh;

  final List<three.Mesh> obstacles = [];
  final List<three.Mesh> collectibles = [];
  final List<three.Mesh> lasers = [];
  final List<three.Mesh> debrisList = [];

  // Spawning controls
  double spawnTimer = 0.0;

  @override
  void initState() {
    super.initState();
    threeJs = three.ThreeJS(
      onSetupComplete: () {
        if (mounted) {
          context.read<GlbModelGameBloc>().add(ThreeJsSetupComplete());
        }
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
    final bloc = context.read<GlbModelGameBloc>();
    try {
      // 1. Perspective Camera
      threeJs.camera = three.PerspectiveCamera(
          60, threeJs.width / threeJs.height, 0.1, 1000);
      threeJs.camera.position.setValues(0, 2.0, 9.0);
      threeJs.camera.lookAt(three.Vector3(0, 0, -25));

      // 2. 3D Scene setup
      threeJs.scene = three.Scene();
      threeJs.scene.fog = three.FogExp2(0x060614, 0.004);

      // 3. Lighting (Dynamic Neon look)
      final ambientLight = three.AmbientLight(0xffffff, 0.35);
      threeJs.scene.add(ambientLight);

      final directionalLight = three.DirectionalLight(0xff00ff, 0.8);
      directionalLight.position.setValues(-10, 15, 10);
      threeJs.scene.add(directionalLight);

      final keyLight = three.DirectionalLight(0x00ffff, 0.9);
      keyLight.position.setValues(10, 5, 20);
      threeJs.scene.add(keyLight);

      final pointLight = three.PointLight(0xff0055, 2.0, 40);
      pointLight.position.setValues(0, 0, -5);
      threeJs.scene.add(pointLight);

      // 4. Warp Speed Starfield
      const starCount = 1500;
      final starGeometry = three.BufferGeometry();
      final starPositions = Float32List(starCount * 3);
      final starSpeeds = Float32List(starCount);

      final random = math.Random();
      for (int i = 0; i < starCount; i++) {
        starPositions[i * 3] = (random.nextDouble() - 0.5) * 120.0;
        starPositions[i * 3 + 1] = (random.nextDouble() - 0.5) * 90.0;
        starPositions[i * 3 + 2] = -random.nextDouble() * 400.0;
        starSpeeds[i] = 1.5 + random.nextDouble() * 3.5;
      }

      starGeometry.setAttributeFromString(
          'position', three.Float32BufferAttribute(starPositions, 3));
      final starMaterial = three.PointsMaterial.fromMap({
        'color': 0xffffff,
        'size': 0.3,
        'transparent': true,
        'opacity': 0.8
      });
      starfield = three.Points(starGeometry, starMaterial);
      starfield.userData = {'speeds': starSpeeds};
      threeJs.scene.add(starfield);

      // 5. Player Spaceship GLB Container Group
      playerGroup = three.Group();
      threeJs.scene.add(playerGroup);

      // Load Single Spaceship GLB Model
      await _loadGlbSpaceship();

      // 7. Register Framerate updates
      threeJs.addAnimationEvent(update);

      bloc.add(SetEngineInitialized());
    } catch (e, stack) {
      debugPrint("3D Flight GLB Engine error: $e\n$stack");
      bloc.add(SetEngineError(e.toString()));
    }
  }

  Future<void> _loadGlbSpaceship() async {
    if (currentGlbMesh != null) {
      playerGroup.remove(currentGlbMesh!);
      currentGlbMesh = null;
    }

    try {
      final loader = three.GLTFLoader();
      final gltf = await loader.fromAsset(spaceshipModel.assetPath);
      if (gltf?.scene != null) {
        currentGlbMesh = gltf!.scene;
        final s = spaceshipModel.defaultScale;
        currentGlbMesh!.scale.setValues(s, s, s);
        currentGlbMesh!.rotation.y = math.pi / 2;
        playerGroup.add(currentGlbMesh!);
        updatePlayerModel();
        return;
      }
    } catch (e) {
      debugPrint("GLTFLoader asset notice: $e, initializing high-detail Sci-Fi Spaceship mesh fallback");
    }

    // High-quality 3D Sci-Fi Spaceship fallback model
    currentGlbMesh = createSpaceshipGlbFallback();
    currentGlbMesh!.rotation.y = math.pi / 2;
    playerGroup.add(currentGlbMesh!);
    updatePlayerModel();
  }

  void updatePlayerModel() {
    playerGroup.position.x = playerX;
    playerGroup.position.y = playerY;
    playerGroup.position.z = 0.0;
  }

  void startGame() {
    final bloc = context.read<GlbModelGameBloc>();
    if (!(bloc.state.initialized.value ?? false)) return;

    speedMultiplier = 1.0;
    playerX = 0.0;
    playerY = 0.0;
    laserHeat = 0.0;
    laserOverheated = false;

    bloc.add(StartGame());

    // Clear active scene meshes
    for (var obs in obstacles) {
      threeJs.scene.remove(obs);
    }
    for (var col in collectibles) {
      threeJs.scene.remove(col);
    }
    for (var laser in lasers) {
      threeJs.scene.remove(laser);
    }
    for (var deb in debrisList) {
      threeJs.scene.remove(deb);
    }

    obstacles.clear();
    collectibles.clear();
    lasers.clear();
    debrisList.clear();

    updatePlayerModel();
  }

  void fireLasers() {
    if (shootCooldown > 0.0 || laserOverheated) return;

    final bloc = context.read<GlbModelGameBloc>();

    // Heat up weapon
    laserHeat += 18.0;
    if (laserHeat >= 100.0) {
      laserHeat = 100.0;
      laserOverheated = true;
    }
    shootCooldown = 0.15;

    bloc.add(UpdateLaserHeat(heat: laserHeat, overheated: laserOverheated));

    // Create laser cylinders
    final laserGeom = three.CylinderGeometry(0.04, 0.04, 1.8, 4);
    laserGeom.rotateX(math.pi / 2);
    final laserMat = three.MeshBasicMaterial.fromMap({
      'color': 0x00f0ff,
      'transparent': true,
      'opacity': 0.95
    });

    // Left cannon laser
    final laserL = three.Mesh(laserGeom, laserMat);
    laserL.position.setValues(playerX - 1.35, playerY - 0.1, -0.6);
    threeJs.scene.add(laserL);
    lasers.add(laserL);

    // Right cannon laser
    final laserR = three.Mesh(laserGeom, laserMat);
    laserR.position.setValues(playerX + 1.35, playerY - 0.1, -0.6);
    threeJs.scene.add(laserR);
    lasers.add(laserR);
  }

  void createExplosion(three.Vector3 position, int colorHex, {int sizeMultiplier = 1}) {
    final random = math.Random();
    final count = (8 + random.nextInt(6)) * sizeMultiplier;
    final geom = three.BoxGeometry(0.3, 0.3, 0.3);
    final mat = three.MeshBasicMaterial.fromMap({
      'color': colorHex,
      'transparent': true,
      'opacity': 0.9
    });

    for (int i = 0; i < count; i++) {
      final deb = three.Mesh(geom, mat);
      deb.position.setValues(position.x, position.y, position.z);

      final theta = random.nextDouble() * math.pi * 2;
      final phi = math.acos(2.0 * random.nextDouble() - 1.0);
      final double speed = 10.0 + random.nextDouble() * 20.0;

      final vx = math.sin(phi) * math.cos(theta) * speed;
      final vy = math.sin(phi) * math.sin(theta) * speed;
      final vz = math.cos(phi) * speed;

      deb.userData = {
        'velocity': three.Vector3(vx, vy, vz),
        'life': 1.0,
      };

      threeJs.scene.add(deb);
      debrisList.add(deb);
    }
  }

  void update(double dt) {
    final bloc = context.read<GlbModelGameBloc>();
    if (!(bloc.state.gameRunning.value ?? false)) return;

    final random = math.Random();

    // Speed scaling over time
    speedMultiplier += 0.012 * dt;
    final currentSpeed = baseShipSpeed * speedMultiplier;

    // 1. Controls processing (Keyboard + Touch inputs from BLoC state)
    double speedX = 18.0;
    double speedY = 14.0;
    double steerX = 0.0;
    double steerY = 0.0;

    if (keyLeft) steerX = -1.0;
    if (keyRight) steerX = 1.0;
    if (keyUp) steerY = 1.0;
    if (keyDown) steerY = -1.0;

    final touchXOffset = bloc.state.touchXOffset.value ?? 0.0;
    final touchYOffset = bloc.state.touchYOffset.value ?? 0.0;
    final touchFiring = bloc.state.touchFiring.value ?? false;

    // Blend touch joystick controls
    if (touchXOffset.abs() > 0.01) steerX = touchXOffset.clamp(-1.0, 1.0);
    if (touchYOffset.abs() > 0.01) steerY = touchYOffset.clamp(-1.0, 1.0);

    // Apply movement
    playerX += steerX * speedX * dt;
    playerY += steerY * speedY * dt;

    // Dynamic bounds confinement based on screen aspect ratio
    final double aspect = (threeJs.width > 0 && threeJs.height > 0)
        ? (threeJs.width / threeJs.height)
        : 16.0 / 9.0;
    final double halfFovRad = 30.0 * math.pi / 180.0;
    final double visibleHeight = 2.0 * 8.5 * math.tan(halfFovRad);
    final double visibleWidth = visibleHeight * aspect;

    final double dynamicBoundsX = (visibleWidth / 2.0) * 0.82;
    final double dynamicBoundsY = (visibleHeight / 2.0) * 0.82;

    playerX = playerX.clamp(-dynamicBoundsX, dynamicBoundsX);
    playerY = playerY.clamp(-dynamicBoundsY, dynamicBoundsY);
    updatePlayerModel();

    // Spaceship roll/pitch banking animation
    double targetRoll = -steerX * 0.45;
    double targetPitch = steerY * 0.3;
    double targetYaw = math.pi - (steerX * 0.15);

    playerGroup.rotation.z += (targetRoll - playerGroup.rotation.z) * 10 * dt;
    playerGroup.rotation.x += (targetPitch - playerGroup.rotation.x) * 10 * dt;
    playerGroup.rotation.y += (targetYaw - playerGroup.rotation.y) * 10 * dt;

    // Engine flame animation
    final flame = playerGroup.getObjectByName("engineFlame");
    if (flame != null) {
      flame.scale.y = 1.0 + math.sin(DateTime.now().millisecondsSinceEpoch * 0.09) * 0.45;
      flame.scale.x = 1.0 + math.cos(DateTime.now().millisecondsSinceEpoch * 0.09) * 0.12;
    }

    // Weapons cooling & firing logic
    if (shootCooldown > 0.0) shootCooldown -= dt;
    if (laserHeat > 0.0) {
      laserHeat -= 30.0 * dt;
      if (laserHeat < 0.0) laserHeat = 0.0;
      if (laserOverheated && laserHeat < 20.0) {
        laserOverheated = false;
      }
      bloc.add(UpdateLaserHeat(heat: laserHeat, overheated: laserOverheated));
    }

    if (keySpace || touchFiring) {
      fireLasers();
    }

    // 2. Camera tracking ship (Smooth lerp + Collision Shake)
    double targetCamX = playerX * 0.68;
    double targetCamY = 1.8 + (playerY * 0.65);
    threeJs.camera.position.x += (targetCamX - threeJs.camera.position.x) * 6 * dt;
    threeJs.camera.position.y += (targetCamY - threeJs.camera.position.y) * 6 * dt;
    threeJs.camera.position.z = 8.5;

    // Screen Shake decay
    if (cameraShakeIntensity > 0.01) {
      final double shakeX = (random.nextDouble() - 0.5) * cameraShakeIntensity;
      final double shakeY = (random.nextDouble() - 0.5) * cameraShakeIntensity;
      threeJs.camera.position.x += shakeX;
      threeJs.camera.position.y += shakeY;
      cameraShakeIntensity *= 0.88;
    }

    threeJs.camera.lookAt(three.Vector3(playerX * 0.35, playerY * 0.35, -35.0));

    // 3. Spawner Logic
    spawnTimer += dt;
    final double spawnInterval = (0.7 / speedMultiplier).clamp(0.25, 1.2);
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0.0;
      spawnObstacleOrCollectible();
    }

    // 4. Lasers progression
    for (int i = lasers.length - 1; i >= 0; i--) {
      final laser = lasers[i];
      laser.position.z -= 230.0 * dt;

      if (laser.position.z < -320.0) {
        threeJs.scene.remove(laser);
        lasers.removeAt(i);
      }
    }

    // 5. Obstacles updates
    for (int i = obstacles.length - 1; i >= 0; i--) {
      final obs = obstacles[i];
      obs.position.z += currentSpeed * dt;

      final double rotSpeedX = obs.userData['rotSpeedX'] ?? 1.0;
      final double rotSpeedY = obs.userData['rotSpeedY'] ?? 1.0;
      obs.rotation.x += rotSpeedX * dt;
      obs.rotation.y += rotSpeedY * dt;

      // Laser collision check
      bool laserHit = false;
      for (int l = lasers.length - 1; l >= 0; l--) {
        final laser = lasers[l];
        final double ldx = laser.position.x - obs.position.x;
        final double ldy = laser.position.y - obs.position.y;
        final double ldz = laser.position.z - obs.position.z;
        final double lDistSq = ldx * ldx + ldy * ldy + ldz * ldz;
        final double hitRadius = (obs.userData['size'] ?? 1.5) + 0.45;

        if (lDistSq < hitRadius * hitRadius) {
          laserHit = true;
          threeJs.scene.remove(laser);
          lasers.removeAt(l);
          break;
        }
      }

      if (laserHit) {
        createExplosion(obs.position, obs.userData['color'] ?? 0xff5500, sizeMultiplier: 2);
        threeJs.scene.remove(obs);
        obstacles.removeAt(i);
        bloc.add(const UpdateScore(150));
        continue;
      }

      // Ship-Obstacle crash logic
      if (obs.position.z.abs() < collisionZThreshold) {
        final double dx = playerX - obs.position.x;
        final double dy = playerY - obs.position.y;
        final double distanceSq = dx * dx + dy * dy;
        final double colRadius = (obs.userData['size'] ?? 1.5) + 0.7;

        if (distanceSq < colRadius * colRadius) {
          createExplosion(obs.position, 0xff003c, sizeMultiplier: 3);
          cameraShakeIntensity = 0.65;
          threeJs.scene.remove(obs);
          obstacles.removeAt(i);

          bloc.add(const DamageShield(25));
          continue;
        }
      }

      // Out of bounds cleanup
      if (obs.position.z > 15.0) {
        threeJs.scene.remove(obs);
        obstacles.removeAt(i);
        bloc.add(UpdateScore((45 * speedMultiplier).round()));
      }
    }

    // 6. Collectibles updates
    for (int i = collectibles.length - 1; i >= 0; i--) {
      final col = collectibles[i];
      col.position.z += currentSpeed * dt;
      col.rotation.y += 2.5 * dt;
      col.rotation.x += 1.2 * dt;

      if (col.position.z.abs() < collisionZThreshold) {
        final double dx = playerX - col.position.x;
        final double dy = playerY - col.position.y;
        final double distanceSq = dx * dx + dy * dy;
        const double collectRadius = 1.8;

        if (distanceSq < collectRadius * collectRadius) {
          final int type = col.userData['type'] ?? 0;
          if (type == 1) {
            bloc.add(const RepairShield(20));
            createExplosion(col.position, 0x00ff88, sizeMultiplier: 1);
          } else {
            bloc.add(const UpdateScore(350));
            createExplosion(col.position, 0x00f0ff, sizeMultiplier: 1);
          }
          threeJs.scene.remove(col);
          collectibles.removeAt(i);
          continue;
        }
      }

      if (col.position.z > 15.0) {
        threeJs.scene.remove(col);
        collectibles.removeAt(i);
      }
    }

    // 7. Explosion debris update
    for (int i = debrisList.length - 1; i >= 0; i--) {
      final deb = debrisList[i];
      final double life = deb.userData['life'] ?? 0.0;

      if (life <= 0.05) {
        threeJs.scene.remove(deb);
        debrisList.removeAt(i);
      } else {
        final three.Vector3 vel = deb.userData['velocity'];
        deb.position.add(vel.clone().scale(dt));
        vel.scale(0.92);

        deb.rotation.x += 2.8 * dt;
        deb.rotation.y += 1.6 * dt;

        deb.scale.setValues(life, life, life);
        deb.userData['life'] = life - 1.6 * dt;
      }
    }

    // 8. Starfield update
    final posAttr = starfield.geometry!.getAttributeFromString('position');
    if (posAttr != null) {
      final positions = posAttr.array;
      final speeds = starfield.userData['speeds'];
      final floatSpeed = currentSpeed * 0.22;

      for (int i = 0; i < speeds.length; i++) {
        positions[i * 3 + 2] += (speeds[i] * floatSpeed) * dt;

        if (positions[i * 3 + 2] > 10.0) {
          positions[i * 3] = (random.nextDouble() - 0.5) * 120.0;
          positions[i * 3 + 1] = (random.nextDouble() - 0.5) * 90.0;
          positions[i * 3 + 2] = -400.0 - random.nextDouble() * 50.0;
        }
      }
      posAttr.needsUpdate = true;
    }
  }

  void spawnObstacleOrCollectible() {
    final random = math.Random();

    final double aspect = (threeJs.width > 0 && threeJs.height > 0)
        ? (threeJs.width / threeJs.height)
        : 16.0 / 9.0;
    final double halfFovRad = 30.0 * math.pi / 180.0;
    final double visibleHeight = 2.0 * 8.5 * math.tan(halfFovRad);
    final double visibleWidth = visibleHeight * aspect;

    final double sx = (random.nextDouble() - 0.5) * (visibleWidth * 1.6);
    final double sy = (random.nextDouble() - 0.5) * (visibleHeight * 1.6);
    const double sz = -320.0;

    final double roll = random.nextDouble();

    if (roll < 0.72) {
      final double size = 1.2 + random.nextDouble() * 2.8;
      three.BufferGeometry geom;
      if (random.nextBool()) {
        geom = three.IcosahedronGeometry(size, 0);
      } else {
        geom = three.DodecahedronGeometry(size, 0);
      }

      final rockyColor = random.nextBool() ? 0x805246 : 0x6e6e7d;
      final mat = three.MeshPhongMaterial.fromMap({
        'color': rockyColor,
        'emissive': 0x111116,
        'shininess': 10,
        'flatShading': true
      });

      final obs = three.Mesh(geom, mat);
      obs.position.setValues(sx, sy, sz);
      obs.userData = {
        'size': size,
        'rotSpeedX': (random.nextDouble() - 0.5) * 2.5,
        'rotSpeedY': (random.nextDouble() - 0.5) * 2.5,
        'color': rockyColor
      };

      threeJs.scene.add(obs);
      obstacles.add(obs);
    } else if (roll < 0.90) {
      final geom = three.OctahedronGeometry(0.55, 0);
      final mat = three.MeshPhongMaterial.fromMap({
        'color': 0x00ffff,
        'emissive': 0x005577,
        'shininess': 90,
        'flatShading': true
      });

      final cry = three.Mesh(geom, mat);
      cry.position.setValues(sx, sy, sz);
      cry.userData = {'type': 0};

      threeJs.scene.add(cry);
      collectibles.add(cry);
    } else {
      final geom = three.DodecahedronGeometry(0.5, 0);
      final mat = three.MeshPhongMaterial.fromMap({
        'color': 0x00ff88,
        'emissive': 0x005522,
        'shininess': 90,
        'flatShading': true
      });

      final rep = three.Mesh(geom, mat);
      rep.position.setValues(sx, sy, sz);
      rep.userData = {'type': 1};

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
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.keyA) {
          keyLeft = isDown;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.logicalKey == LogicalKeyboardKey.keyD) {
          keyRight = isDown;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.keyW) {
          keyUp = isDown;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.keyS) {
          keyDown = isDown;
        }
        if (event.logicalKey == LogicalKeyboardKey.space) {
          keySpace = isDown;
        }
        return KeyEventResult.handled;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF060614),
        body: BlocBuilder<GlbModelGameBloc, GlbModelGameState>(
          builder: (context, state) {
            final isInitialized = state.initialized.value ?? false;
            final isGameRunning = state.gameRunning.value ?? false;
            final isGameOver = state.showGameOver.value ?? false;
            final scoreVal = state.score.value ?? 0;
            final shieldVal = state.shield.value ?? 100;
            final laserHeatVal = state.laserHeat.value ?? 0.0;
            final laserOverheatedVal = state.laserOverheated.value ?? false;
            final highScoreVal = state.highScore.value ?? 0;
            final initErrMsg = state.initError.message ?? state.initError.error?.toString();

            return Stack(
              children: [
                // 3D Viewport engine rendering
                Positioned.fill(
                  child: threeJs.build(),
                ),

                if (!isInitialized)
                  GlbGameLoadingOverlay(
                    initError: initErrMsg,
                    onRetry: () {
                      context.read<GlbModelGameBloc>().add(ResetEngine());
                      setup();
                    },
                  ),

                // Space flight status top overlay HUD
                GlbGameHud(
                  score: scoreVal,
                  shield: shieldVal,
                  laserHeat: laserHeatVal,
                  laserOverheated: laserOverheatedVal,
                ),

                // Radar display, controls, and crosshair overlay
                if (isGameRunning) ...[
                  GlbGameRadar(
                    playerX: playerX,
                    obstacles: obstacles,
                    collectibles: collectibles,
                    lasers: lasers,
                  ),

                  GlbGameJoystick(
                    touchXOffset: state.touchXOffset.value ?? 0.0,
                    touchYOffset: state.touchYOffset.value ?? 0.0,
                    onPanUpdate: (details) {
                      final x = (details.localPosition.dx - 50.0) / 40.0;
                      final y = -(details.localPosition.dy - 50.0) / 40.0;
                      context
                          .read<GlbModelGameBloc>()
                          .add(UpdateJoystickOffset(x, y));
                    },
                    onPanEnd: () {
                      context
                          .read<GlbModelGameBloc>()
                          .add(const UpdateJoystickOffset(0.0, 0.0));
                    },
                  ),

                  GlbGameFireButton(
                    touchFiring: state.touchFiring.value ?? false,
                    onPointerDown: () => context
                        .read<GlbModelGameBloc>()
                        .add(const SetTouchFiring(true)),
                    onPointerUp: () => context
                        .read<GlbModelGameBloc>()
                        .add(const SetTouchFiring(false)),
                    onPointerCancel: () => context
                        .read<GlbModelGameBloc>()
                        .add(const SetTouchFiring(false)),
                  ),

                  GlbGameCrosshair(
                    laserOverheated: laserOverheatedVal,
                  ),
                ],

                // Start Screen Panel Overlay
                if (!isGameRunning && !isGameOver)
                  GlbGameStartOverlay(
                    onStart: startGame,
                  ),

                // Game Over overlay HUD screen
                if (isGameOver)
                  GlbGameOverOverlay(
                    score: scoreVal,
                    highScore: highScoreVal,
                    onRelaunch: startGame,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
