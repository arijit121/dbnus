import 'dart:convert';
import 'package:dbnus/core/config/api_config.dart';
import 'package:dbnus/shared/constants/api_url_const.dart';
import 'package:dbnus/core/network/api_client/imp/api_repo_imp.dart';
import 'package:dbnus/core/network/api_client/repo/api_repo.dart';
import 'package:dbnus/core/network/models/api_return_model.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/features/landing/data/models/landing_banner_response.dart';

import 'landing_data_source.dart';

class LandingRemoteDataSourceImpl implements LandingDataSource {
  @override
  Future<LandingBannerResponse?> getSplashBanner() async {
    try {
      Map<String, String> headers = await ApiConfig.getHeaders();
      ApiReturnModel? response = await ApiEngine.instance.callApi(
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
