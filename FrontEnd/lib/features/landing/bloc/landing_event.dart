part of 'landing_bloc.dart';

sealed class LandingEvent extends Equatable {
  const LandingEvent();

  @override
  List<Object> get props => [];
}

class InitiateSplash extends LandingEvent {}

class ChangeIndex extends LandingEvent {
  const ChangeIndex({required this.index});
  final int index;
}
