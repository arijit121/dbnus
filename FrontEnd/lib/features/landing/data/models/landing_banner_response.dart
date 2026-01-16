import 'package:dbnus/features/landing/domain/entities/landing_banner.dart';

class LandingBannerResponse extends LandingBanner {
  LandingBannerResponse({List<String>? data}) : super(data: data);

  LandingBannerResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    return data;
  }
}
