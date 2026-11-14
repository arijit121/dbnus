import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_scene/scene.dart' as scene;
import 'package:vector_math/vector_math.dart' as vm;

import '../../../../../navigation/custom_router/custom_route.dart';
import '../../../../../shared/constants/assects_const.dart';

class OrbitalCollectorPage extends StatefulWidget {
  const OrbitalCollectorPage({super.key});

  @override
  State<OrbitalCollectorPage> createState() => _OrbitalCollectorPageState();
}

class _OrbitalCollectorPageState extends State<OrbitalCollectorPage> {
  static const _background = Color(0xFF050815);
  static const _cyan = Color(0xFF42E8E0);
  static const _violet = Color(0xFF9B7BFF);

  final scene.Scene _scene = scene.Scene();
  final math.Random _random = math.Random(17);
  final List<_DriftObject> _objects = [];
  final List<scene.Node> _gates = [];
  late final Future<void> _sceneReady;
  late final scene.Node _ship;
  final Map<String, scene.AnimationClip> _animationClips = {};
  final List<String> _animationQueue = [];
  scene.AnimationClip? _activeAnimation;

  double _targetX = 0;
  double _targetY = 0;
  int _score = 0;
  int _shields = 3;
  bool _running = false;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _sceneReady = _initializeScene();
  }

  Future<void> _initializeScene() async {
    await scene.Scene.initializeStaticResources();
    if (!mounted) return;

    final playerModel = await scene.Node.fromGlbAsset(
      AssetsConst.dashGlbModel,
    );
    if (!mounted) return;
    _buildScene(playerModel);
  }

  void _buildScene(scene.Node playerModel) {
    for (final name in ['Idle', 'Run', 'JumpStart', 'Jump', 'JumpLand']) {
      final animation = playerModel.findAnimationByName(name);
      if (animation == null) {
        throw StateError('The dash model is missing the "$name" animation.');
      }
      _animationClips[name] = playerModel.createAnimationClip(animation);
    }

    final ship = scene.Node(name: 'player-ship');
    final modelPlacement = scene.Node(name: 'player-ship-model')
      ..position = vm.Vector3(0, -0.65, 0)
      ..scale = vm.Vector3.all(0.45);
    modelPlacement.add(playerModel);
    ship.add(modelPlacement);
    _ship = ship;
    _scene.add(_ship);
    _playAnimation('Idle');

    final starGeometry = scene.SphereGeometry(
      radius: 0.035,
      segments: 6,
      rings: 4,
    );
    final starMaterial = _material(Colors.white, emission: 0.7);
    for (var i = 0; i < 54; i++) {
      final star = scene.Node(
        name: 'star-$i',
        mesh: scene.Mesh(starGeometry, starMaterial),
      )..position = vm.Vector3(
          (_random.nextDouble() - 0.5) * 28,
          (_random.nextDouble() - 0.5) * 17,
          -_random.nextDouble() * 48,
        );
      final size = 0.45 + _random.nextDouble() * 1.7;
      star.scale = vm.Vector3.all(size);
      _scene.add(star);
    }

    final gateGeometry = scene.TorusGeometry(
      radius: 4.8,
      tubeRadius: 0.035,
      radialSegments: 10,
      tubularSegments: 48,
    );
    final gateMaterial = _material(_cyan, emission: 0.16, metallic: 0.7);
    for (var i = 0; i < 5; i++) {
      final gate = scene.Node(
        name: 'flight-gate-$i',
        mesh: scene.Mesh(gateGeometry, gateMaterial),
      )..position = vm.Vector3(0, 0, -8.0 - i * 8.5);
      _gates.add(gate);
      _scene.add(gate);
    }

    final asteroidGeometry =
        scene.IcosphereGeometry(radius: 0.62, subdivisions: 1);
    final asteroidMaterial = _material(
      const Color(0xFF7E7894),
      metallic: 0.28,
      roughness: 0.82,
    );
    final coreGeometry = scene.IcosphereGeometry(radius: 0.42, subdivisions: 2);
    final coreMaterial = _material(_cyan, emission: 0.55, metallic: 0.45);
    for (var i = 0; i < 6; i++) {
      _objects.add(
        _DriftObject(
          scene.Node(
            name: 'asteroid-$i',
            mesh: scene.Mesh(asteroidGeometry, asteroidMaterial),
          ),
          isCore: false,
        ),
      );
    }
    for (var i = 0; i < 5; i++) {
      _objects.add(
        _DriftObject(
          scene.Node(
            name: 'energy-core-$i',
            mesh: scene.Mesh(coreGeometry, coreMaterial),
          ),
          isCore: true,
        ),
      );
    }
    for (final object in _objects) {
      _scene.add(object.node);
      _respawn(object, initial: true);
    }
  }

  void _playAnimation(
    String name, {
    bool loop = true,
    List<String> then = const [],
  }) {
    for (final animation in _animationClips.values) {
      animation
        ..stop()
        ..weight = 0;
    }

    final animation = _animationClips[name]!;
    animation
      ..weight = 1
      ..loop = loop
      ..replay();
    _activeAnimation = animation;
    _animationQueue
      ..clear()
      ..addAll(then);
  }

  void _advanceAnimationSequence() {
    final animation = _activeAnimation;
    if (animation == null || animation.loop || animation.playing) return;

    if (_animationQueue.isNotEmpty) {
      final next = _animationQueue.removeAt(0);
      _playAnimation(next, loop: next == 'Run');
    } else if (_running) {
      _playAnimation('Run');
    } else {
      _playAnimation('Idle');
    }
  }

  scene.PhysicallyBasedMaterial _material(
    Color color, {
    double emission = 0,
    double metallic = 0.35,
    double roughness = 0.4,
  }) {
    return scene.PhysicallyBasedMaterial()
      ..baseColorFactor = vm.Vector4(color.r, color.g, color.b, color.a)
      ..emissiveFactor = vm.Vector4(
        color.r * emission,
        color.g * emission,
        color.b * emission,
        1,
      )
      ..metallicFactor = metallic
      ..roughnessFactor = roughness;
  }

  void _respawn(_DriftObject object, {bool initial = false}) {
    const lanes = [-2.3, -0.8, 0.8, 2.3];
    final lane = lanes[_random.nextInt(lanes.length)];
    final y = (_random.nextDouble() - 0.5) * 1.9;
    final z = initial
        ? -12 - _random.nextDouble() * 30
        : -28 - _random.nextDouble() * 20;
    object.node
      ..position = vm.Vector3(lane, y, z)
      ..rotation = vm.Quaternion.axisAngle(
        vm.Vector3(1, 0.5, 0.25)..normalize(),
        _random.nextDouble() * math.pi * 2,
      );
  }

  void _onSceneTick(Duration _, double deltaSeconds) {
    final dt = deltaSeconds.clamp(0.0, 0.05);
    _advanceAnimationSequence();
    final current = _ship.position;
    final nextX = current.x + (_targetX - current.x) * math.min(1, dt * 7);
    final nextY = current.y + (_targetY - current.y) * math.min(1, dt * 7);
    _ship
      ..position = vm.Vector3(nextX, nextY, 0)
      ..rotation = vm.Quaternion.axisAngle(
        vm.Vector3(0, 0, 1),
        (current.x - nextX) * 0.3,
      );

    for (final gate in _gates) {
      final position = gate.position;
      final nextZ = position.z + dt * 2.8;
      gate.position = vm.Vector3(0, 0, nextZ > 4 ? nextZ - 42.5 : nextZ);
    }

    if (!_running) return;

    var changed = false;
    for (final object in _objects) {
      final position = object.node.position;
      final nextPosition =
          vm.Vector3(position.x, position.y, position.z + dt * 9);
      object.node.position = nextPosition;

      final dx = nextPosition.x - nextX;
      final dy = nextPosition.y - nextY;
      if (nextPosition.z > -1.15 && dx * dx + dy * dy < 1.15 * 1.15) {
        if (object.isCore) {
          _score += 10;
          _playAnimation(
            'JumpStart',
            loop: false,
            then: ['Jump', 'JumpLand', 'Run'],
          );
        } else {
          _shields = math.max(0, _shields - 1);
        }
        _respawn(object);
        changed = true;
      } else if (nextPosition.z > 3) {
        _respawn(object);
      }
    }

    if (_shields == 0) {
      _running = false;
      _gameOver = true;
      _playAnimation('Idle');
      changed = true;
    }
    if (changed && mounted) setState(() {});
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _shields = 3;
      _targetX = 0;
      _targetY = 0;
      _gameOver = false;
      _running = true;
      _playAnimation('Run');
      for (final object in _objects) {
        _respawn(object, initial: true);
      }
    });
  }

  @override
  void dispose() {
    _scene.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _sceneReady,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: _background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not initialize the 3D scene.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: _background,
            body: Center(
              child: CircularProgressIndicator(color: _cyan),
            ),
          );
        }
        return _buildGame();
      },
    );
  }

  Widget _buildGame() {
    final camera = scene.PerspectiveCamera(
      fovRadiansY: 0.82,
      position: vm.Vector3(0, 3.7, 12),
      target: vm.Vector3(0, 0, -14),
    );

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (details) {
                      _targetX = (_targetX -
                              details.delta.dx / constraints.maxWidth * 6.5)
                          .clamp(-3.1, 3.1);
                      _targetY = (_targetY -
                              details.delta.dy / constraints.maxHeight * 4.4)
                          .clamp(-1.7, 1.7);
                    },
                    child: scene.SceneView(
                      _scene,
                      camera: camera,
                      onTick: _onSceneTick,
                      maxFrameRate: 60,
                      pixelRatio: 0.9,
                    ),
                  );
                },
              ),
            ),
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x99050815),
                      Color(0x11050815),
                      Color(0xAA050815),
                    ],
                    stops: [0, 0.48, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: _buildHud(),
            ),
            if (!_running && !_gameOver)
              Positioned.fill(
                child: Center(
                  child: _buildIntroCard(),
                ),
              ),
            if (_gameOver)
              Positioned.fill(
                child: Center(
                  child: _buildGameOverCard(),
                ),
              ),
            if (_running)
              const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Center(
                    child: Text(
                      'DRAG ANYWHERE TO STEER',
                      style: TextStyle(
                        color: Color(0xBFFFFFFF),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
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

  Widget _buildHud() {
    return Column(
      children: [
        Row(
          children: [
            _HudIconButton(
              icon: Icons.arrow_back_rounded,
              onPressed: () {
                CustomRoute.back();
              },
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORBITAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'COLLECTOR  /  3D RUN',
                    style: TextStyle(
                      color: _cyan,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            _StatPill(
              label: 'SCORE',
              value: '$_score',
              icon: Icons.auto_awesome_rounded,
              color: _cyan,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'SHIELDS',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
                      decoration: BoxDecoration(
                        color: index < _shields
                            ? _cyan
                            : Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: index < _shields
                            ? [
                                BoxShadow(
                                  color: _cyan.withValues(alpha: 0.48),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$_shields / 3',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntroCard() {
    return _GameCard(
      eyebrow: 'FLIGHT BRIEFING',
      title: 'Collect the cores.\nMiss the rocks.',
      description:
          'Pilot through the orbital field, grab glowing energy cores, and keep your shields intact.',
      buttonLabel: 'START FLIGHT',
      icon: Icons.rocket_launch_rounded,
      onPressed: _startGame,
      footer: 'DRAG TO MOVE  ·  +10 PER CORE',
    );
  }

  Widget _buildGameOverCard() {
    return _GameCard(
      eyebrow: 'FLIGHT COMPLETE',
      title: 'Run ended',
      description:
          'You collected $_score energy points before your shields failed.',
      buttonLabel: 'FLY AGAIN',
      icon: Icons.replay_rounded,
      onPressed: _startGame,
      footer: 'FINAL SCORE  ·  $_score',
    );
  }
}

class _DriftObject {
  const _DriftObject(this.node, {required this.isCore});

  final scene.Node node;
  final bool isCore;
}

class _HudIconButton extends StatelessWidget {
  const _HudIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xBB11182A),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xBB11182A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.icon,
    required this.onPressed,
    required this.footer,
  });

  final String eyebrow;
  final String title;
  final String description;
  final String buttonLabel;
  final IconData icon;
  final VoidCallback onPressed;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xEE0D1425),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: _OrbitalCollectorPageState._cyan.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: _OrbitalCollectorPageState._cyan.withValues(alpha: 0.1),
            blurRadius: 36,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                      _OrbitalCollectorPageState._cyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: _OrbitalCollectorPageState._cyan,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                eyebrow,
                style: const TextStyle(
                  color: _OrbitalCollectorPageState._cyan,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF9BA7C1),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _OrbitalCollectorPageState._cyan,
                foregroundColor: const Color(0xFF061019),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              footer,
              style: const TextStyle(
                color: Color(0xFF7C88A2),
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
