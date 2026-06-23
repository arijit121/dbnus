import 'package:dbnus/features/landing/domain/entities/landing_banner.dart';

abstract class LandingRepository {
  Future<LandingBanner?> getSplashBanner();
}
