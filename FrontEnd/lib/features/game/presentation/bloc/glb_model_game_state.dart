part of 'glb_model_game_bloc.dart';

class GlbModelGameState extends Equatable {
  final DynamicBlocData<int> score;
  final DynamicBlocData<int> shield;
  final DynamicBlocData<int> highScore;
  final DynamicBlocData<bool> gameRunning;
  final DynamicBlocData<bool> showGameOver;
  final DynamicBlocData<bool> initialized;
  final DynamicBlocData<String?> initError;
  final DynamicBlocData<double> laserHeat;
  final DynamicBlocData<bool> laserOverheated;
  final DynamicBlocData<bool> threeJsReady;
  final DynamicBlocData<double> touchXOffset;
  final DynamicBlocData<double> touchYOffset;
  final DynamicBlocData<bool> touchFiring;

  const GlbModelGameState({
    required this.score,
    required this.shield,
    required this.highScore,
    required this.gameRunning,
    required this.showGameOver,
    required this.initialized,
    required this.initError,
    required this.laserHeat,
    required this.laserOverheated,
    required this.threeJsReady,
    required this.touchXOffset,
    required this.touchYOffset,
    required this.touchFiring,
  });

  factory GlbModelGameState.initial() {
    return const GlbModelGameState(
      score: DynamicBlocData<int>.success(value: 0),
      shield: DynamicBlocData<int>.success(value: 100),
      highScore: DynamicBlocData<int>.success(value: 0),
      gameRunning: DynamicBlocData<bool>.success(value: false),
      showGameOver: DynamicBlocData<bool>.success(value: false),
      initialized: DynamicBlocData<bool>.init(value: false),
      initError: DynamicBlocData<String?>.init(value: null),
      laserHeat: DynamicBlocData<double>.success(value: 0.0),
      laserOverheated: DynamicBlocData<bool>.success(value: false),
      threeJsReady: DynamicBlocData<bool>.init(value: false),
      touchXOffset: DynamicBlocData<double>.success(value: 0.0),
      touchYOffset: DynamicBlocData<double>.success(value: 0.0),
      touchFiring: DynamicBlocData<bool>.success(value: false),
    );
  }

  GlbModelGameState copyWith({
    DynamicBlocData<int>? score,
    DynamicBlocData<int>? shield,
    DynamicBlocData<int>? highScore,
    DynamicBlocData<bool>? gameRunning,
    DynamicBlocData<bool>? showGameOver,
    DynamicBlocData<bool>? initialized,
    DynamicBlocData<String?>? initError,
    DynamicBlocData<double>? laserHeat,
    DynamicBlocData<bool>? laserOverheated,
    DynamicBlocData<bool>? threeJsReady,
    DynamicBlocData<double>? touchXOffset,
    DynamicBlocData<double>? touchYOffset,
    DynamicBlocData<bool>? touchFiring,
  }) {
    return GlbModelGameState(
      score: score ?? this.score,
      shield: shield ?? this.shield,
      highScore: highScore ?? this.highScore,
      gameRunning: gameRunning ?? this.gameRunning,
      showGameOver: showGameOver ?? this.showGameOver,
      initialized: initialized ?? this.initialized,
      initError: initError ?? this.initError,
      laserHeat: laserHeat ?? this.laserHeat,
      laserOverheated: laserOverheated ?? this.laserOverheated,
      threeJsReady: threeJsReady ?? this.threeJsReady,
      touchXOffset: touchXOffset ?? this.touchXOffset,
      touchYOffset: touchYOffset ?? this.touchYOffset,
      touchFiring: touchFiring ?? this.touchFiring,
    );
  }

  @override
  List<Object?> get props => [
        score,
        shield,
        highScore,
        gameRunning,
        showGameOver,
        initialized,
        initError,
        laserHeat,
        laserOverheated,
        threeJsReady,
        touchXOffset,
        touchYOffset,
        touchFiring,
      ];
}
