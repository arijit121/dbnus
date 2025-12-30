part of 'landing_bloc.dart';

class LandingState extends Equatable {
  final DynamicBlocData<LandingBannerResponse> bannerData;
  final DynamicBlocData<int> pageIndex;
  final DynamicBlocData<Widget> page;

  const LandingState({
    required this.bannerData,
    required this.pageIndex,
    required this.page,
  });

  factory LandingState.initial() {
    return LandingState(
        bannerData: DynamicBlocData<LandingBannerResponse>.init(),
        pageIndex: DynamicBlocData.init(),
        page: DynamicBlocData.init());
  }

  LandingState copyWith(
      {DynamicBlocData<LandingBannerResponse>? bannerData,
      DynamicBlocData<int>? pageIndex,
      DynamicBlocData<Widget>? page}) {
    return LandingState(
        bannerData: bannerData ?? this.bannerData,
        pageIndex: pageIndex ?? this.pageIndex,
        page: page ?? this.page);
  }

  @override
  List<Object> get props => [bannerData.status, pageIndex.status, page.status];
}
