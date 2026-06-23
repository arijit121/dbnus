import '../models/landing_banner_response.dart';
import 'landing_data_source.dart';

class LandingMockDataSource implements LandingDataSource {
  @override
  Future<LandingBannerResponse?> getSplashBanner() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return LandingBannerResponse(
      data: [
        'https://via.placeholder.com/800x400.png?text=Mock+Banner+1',
        'https://via.placeholder.com/800x400.png?text=Mock+Banner+2',
        'https://via.placeholder.com/800x400.png?text=Mock+Banner+3',
      ],
    );
  }
}
