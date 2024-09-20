import 'dart:convert';

import '../../../data/env/app_urls.dart';
import '../../../data/network/base_api_service.dart';
import '../../../data/network/network_api_services.dart';
import '../../../data/request_builder.dart';
import '../../../utils/app_log.dart';
import '../../base/parser/base_parser.dart';

class CrashRepo {
  BaseApiServices apiServices = NetworkApiService();

  Future<Map?> crashApiSubmit({required Map params}) async {
    try {
      var data = await requestBuilderV2(
        group: "bulkbuyer_common",
        subGroup: "mobileApi",
        section: "AppError",
        param: params,
      );

      var response = await apiServices.getPostApiResponseV2(
        "crashApiSubmit",
        AppUrls().indexV2PostUrl(),
        json.encode(data),
      );
      if (BaseParser().getStatusFromResponse(resp: response) == API_SUCCESS) {
        return response["ResponseData"] ?? {};
      } else {
        return null;
      }
    } catch (e) {
      AppLog()
          .errLog(err: "err request Crash Submit Api Call - ${e.toString()}");
    }
  }
}
