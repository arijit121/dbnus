import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/dynamic_data.dart';

part 'glb_model_game_event.dart';
part 'glb_model_game_state.dart';

class GlbModelGameBloc extends Bloc<GlbModelGameEvent, GlbModelGameState> {
  GlbModelGameBloc() : super(GlbModelGameState.initial()) {
    on<ThreeJsSetupComplete>(_onThreeJsSetupComplete);
    on<SetEngineInitialized>(_onSetEngineInitialized);
    on<SetEngineError>(_onSetEngineError);
    on<ResetEngine>(_onResetEngine);
    on<StartGame>(_onStartGame);
    on<GameOver>(_onGameOver);
    on<UpdateScore>(_onUpdateScore);
    on<DamageShield>(_onDamageShield);
    on<RepairShield>(_onRepairShield);
    on<UpdateLaserHeat>(_onUpdateLaserHeat);
    on<UpdateJoystickOffset>(_onUpdateJoystickOffset);
    on<SetTouchFiring>(_onSetTouchFiring);
  }

  void _onThreeJsSetupComplete(
      ThreeJsSetupComplete event, Emitter<GlbModelGameState> emit) {
    emit(state.copyWith(
      threeJsReady: const DynamicBlocData<bool>.success(value: true),
    ));
  }

  void _onSetEngineInitialized(
      SetEngineInitialized event, Emitter<GlbModelGameState> emit) {
    emit(state.copyWith(
      initialized: const DynamicBlocData<bool>.success(value: true),
      initError: const DynamicBlocData<String?>.init(value: null),
    ));
  }

  void _onSetEngineError(
      SetEngineError event, Emitter<GlbModelGameState> emit) {
    emit(state.copyWith(
      initError: DynamicBlocData<String?>.error(
          message: event.error, error: event.error),
      initialized: const DynamicBlocData<bool>.success(value: false),
    ));
  }

  void _onResetEngine(ResetEngine event, Emitter<GlbModelGameState> emit) {
    emit(state.copyWith(
      initError: const DynamicBlocData<String?>.init(value: null),
      initialized: const DynamicBlocData<bool>.success(value: false),
    ));
  }

  void _onStartGame(StartGame event, Emitter<GlbModelGameState> emit) {
    emit(state.copyWith(
      score: const DynamicBlocData<int>.success(value: 0),
      shield: const DynamicBlocData<int>.success(value: 100),
      laserHeat: const DynamicBlocData<double>.success(value: 0.0),
      laserOverheated: const DynamicBlocData<bool>.success(value: false),
      gameRunning: const DynamicBlocData<bool>.success(value: true),
      showGameOver: const DynamicBlocData<bool>.success(value: false),
      touchXOffset: const DynamicBlocData<double>.success(value: 0.0),
      touchYOffset: const DynamicBlocData<double>.success(value: 0.0),
      touchFiring: const DynamicBlocData<bool>.success(value: false),
    ));
  }

  void _onGameOver(GameOver event, Emitter<GlbModelGameState> emit) {
    final currentScore = state.score.value ?? 0;
    final currentHighScore = state.highScore.value ?? 0;
    final newHighScore =
        currentScore > currentHighScore ? currentScore : currentHighScore;

    emit(state.copyWith(
      gameRunning: const DynamicBlocData<bool>.success(value: false),
      showGameOver: const DynamicBlocData<bool>.success(value: true),
      highScore: DynamicBlocData<int>.success(value: newHighScore),
    ));
  }

  void _onUpdateScore(UpdateScore event, Emitter<GlbModelGameState> emit) {
    final currentScore = state.score.value ?? 0;
    emit(state.copyWith(
      score: DynamicBlocData<int>.success(value: currentScore + event.points),
    ));
  }

  void _onDamageShield(DamageShield event, Emitter<GlbModelGameState> emit) {
    final currentShield = state.shield.value ?? 100;
    final newShield = (currentShield - event.damage).clamp(0, 100);

    emit(state.copyWith(
      shield: DynamicBlocData<int>.success(value: newShield),
    ));

    if (newShield <= 0 && (state.gameRunning.value ?? false)) {
      add(GameOver());
    }
  }

  void _onRepairShield(RepairShield event, Emitter<GlbModelGameState> emit) {
    final currentShield = state.shield.value ?? 100;
    final newShield = (currentShield + event.amount).clamp(0, 100);

    emit(state.copyWith(
      shield: DynamicBlocData<int>.success(value: newShield),
    ));
  }

  void _onUpdateLaserHeat(
      UpdateLaserHeat event, Emitter<GlbModelGameState> emit) {
    emit(state.copyWith(
      laserHeat: DynamicBlocData<double>.success(value: event.heat),
      laserOverheated: DynamicBlocData<bool>.success(value: event.overheated),
    ));
  }

  void _onUpdateJoystickOffset(
      UpdateJoystickOffset event, Emitter<GlbModelGameState> emit) {
    emit(state.copyWith(
      touchXOffset: DynamicBlocData<double>.success(value: event.x),
      touchYOffset: DynamicBlocData<double>.success(value: event.y),
    ));
  }

  void _onSetTouchFiring(
      SetTouchFiring event, Emitter<GlbModelGameState> emit) {
    emit(state.copyWith(
      touchFiring: DynamicBlocData<bool>.success(value: event.isFiring),
    ));
  }
}
