part of 'landing_bloc.dart';

abstract class LandingEvent extends Equatable {
  const LandingEvent();
}

class InitiateSplash extends LandingEvent {
  @override
  List<Object?> get props => [];
}
//ignore: must_be_immutable
class UpdateBannerIndex extends LandingEvent {
  UpdateBannerIndex({required this.index});

  int index;

  @override
  List<Object?> get props => [index];
}
