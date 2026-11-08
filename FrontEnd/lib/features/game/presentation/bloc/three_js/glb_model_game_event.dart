part of 'glb_model_game_bloc.dart';

sealed class GlbModelGameEvent extends Equatable {
  const GlbModelGameEvent();

  @override
  List<Object?> get props => [];
}

class ThreeJsSetupComplete extends GlbModelGameEvent {}

class SetEngineInitialized extends GlbModelGameEvent {}

class SetEngineError extends GlbModelGameEvent {
  final String error;
  const SetEngineError(this.error);

  @override
  List<Object?> get props => [error];
}

class ResetEngine extends GlbModelGameEvent {}

class StartGame extends GlbModelGameEvent {}

class GameOver extends GlbModelGameEvent {}

class UpdateScore extends GlbModelGameEvent {
  final int points;
  const UpdateScore(this.points);

  @override
  List<Object?> get props => [points];
}

class DamageShield extends GlbModelGameEvent {
  final int damage;
  const DamageShield(this.damage);

  @override
  List<Object?> get props => [damage];
}

class RepairShield extends GlbModelGameEvent {
  final int amount;
  const RepairShield(this.amount);

  @override
  List<Object?> get props => [amount];
}

class UpdateLaserHeat extends GlbModelGameEvent {
  final double heat;
  final bool overheated;
  const UpdateLaserHeat({required this.heat, required this.overheated});

  @override
  List<Object?> get props => [heat, overheated];
}

class UpdateJoystickOffset extends GlbModelGameEvent {
  final double x;
  final double y;
  const UpdateJoystickOffset(this.x, this.y);

  @override
  List<Object?> get props => [x, y];
}

class SetTouchFiring extends GlbModelGameEvent {
  final bool isFiring;
  const SetTouchFiring(this.isFiring);

  @override
  List<Object?> get props => [isFiring];
}
