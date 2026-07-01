import 'dart:convert';
import 'package:dbnus/core/config/api_config.dart';
import 'package:dbnus/shared/constants/api_url_const.dart';
import 'package:dbnus/core/network/api_client/imp/api_repo_imp.dart';
import 'package:dbnus/core/network/api_client/repo/api_repo.dart';
import 'package:dbnus/core/network/models/api_return_model.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/features/dashboard/data/models/dashboard_data_response.dart';

import 'dashboard_data_source.dart';

class DashboardRemoteDataSourceImpl implements DashboardDataSource {
  @override
  Future<DashboardDataResponse?> getDashboardData() async {
    try {
      Map<String, String> headers = await ApiConfig.getHeaders();
      ApiReturnModel? response = await ApiEngine.instance.callApi(
          tag: 'DashboardData',
          uri: ApiUrlConst.books, // Using books URL as a dummy endpoint
          method: Method.get,
          headers: headers,
          queryParameters: {
            "q": "dashboard",
          });
      if (response?.responseString != null) {
        var v = json.decode(response?.responseString ?? "");
        DashboardDataResponse dashboardDataResponse =
            DashboardDataResponse.fromJson(v);
        return dashboardDataResponse;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }
}
