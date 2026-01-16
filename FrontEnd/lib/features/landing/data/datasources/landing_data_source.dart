import '../models/landing_banner_response.dart';

abstract class LandingDataSource {
  Future<LandingBannerResponse?> getSplashBanner();
}
