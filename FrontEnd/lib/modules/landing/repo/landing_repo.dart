import 'dart:convert';

import '../../../config/api_config.dart';
import '../../../const/api_url_const.dart';
import '../../../data/api_client/imp/api_repo_imp.dart';
import '../../../data/api_client/repo/api_repo.dart';
import '../../../data/model/api_return_model.dart';
import '../../../extension/logger_extension.dart';
import '../model/landing_banner_response.dart';

class LandingRepo {
  Future<LandingBannerResponse?> getSplashBanner() async {
    try {
      Map<String, String> headers = await ApiConfig.getHeaders();
      ApiReturnModel? response = await ApiEngine.callApi(
          tag: 'Books',
          uri: ApiUrlConst.books,
          method: Method.get,
          headers: headers,
          queryParameters: {
            "q": "search+terms",
          });
      if (response?.responseString != null) {
        var v = json.decode(response?.responseString ?? "");
        LandingBannerResponse splashBannerResponse =
            LandingBannerResponse.fromJson(v);
        return splashBannerResponse;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }
}
