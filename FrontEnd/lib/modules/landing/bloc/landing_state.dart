part of 'landing_bloc.dart';
//ignore: must_be_immutable
class LandingState extends Equatable {
  DynamicBlocData<LandingBannerResponse> bannerData;
  DynamicBlocData<int> bannerIndex;

  LandingState({
    required this.bannerData,
    required this.bannerIndex,
  });

  LandingState copyWith(
      {DynamicBlocData<LandingBannerResponse>? bannerData,
      DynamicBlocData<int>? bannerIndex}) {
    return LandingState(
        bannerData: bannerData ?? this.bannerData,
        bannerIndex: bannerIndex ?? this.bannerIndex);
  }

  @override
  List<Object> get props => [bannerData.status, bannerIndex.status];
}
