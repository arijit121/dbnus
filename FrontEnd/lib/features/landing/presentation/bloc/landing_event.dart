part of 'landing_bloc.dart';

sealed class LandingEvent extends Equatable {
  const LandingEvent();

  @override
  List<Object> get props => [];
}

class Init extends LandingEvent {}

class GetSplashData extends LandingEvent {}

class ChangeIndex extends LandingEvent {
  const ChangeIndex({required this.index});
  final int index;
}
