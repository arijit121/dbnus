part of 'landing_bloc.dart';

//ignore: must_be_immutable
class LandingState extends Equatable {
  DynamicBlocData<LandingBannerResponse> bannerData;
  DynamicBlocData<int> pageIndex;

  LandingState({
    required this.bannerData,
    required this.pageIndex,
  });

  LandingState copyWith(
      {DynamicBlocData<LandingBannerResponse>? bannerData,
      DynamicBlocData<int>? pageIndex}) {
    return LandingState(
        bannerData: bannerData ?? this.bannerData,
        pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object> get props => [bannerData.status, pageIndex.status];
}
