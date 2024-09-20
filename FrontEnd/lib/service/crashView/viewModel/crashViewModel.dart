import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../data/response/api_response.dart';
import '../../../utils/app_log.dart';
import '../../../utils/user/user_session.dart';
import '../repo/crashRepo.dart';

class CrashViewModel with ChangeNotifier {
  Map<String, dynamic>? errorVm;
  final _myRepo = CrashRepo();

  CrashViewModel({Map<String, dynamic>? errorDetails}) {
    errorVm = errorDetails;
    crashApiSubmit();
    notifyListeners();
  }

  ApiResponse<Map?> crashApiSubmitValue = ApiResponse.start();

  syncCrashApiSubmit(ApiResponse<Map?> response) {
    crashApiSubmitValue = response;
    notifyListeners();
  }

  void crashApiSubmit() async {
    syncCrashApiSubmit(ApiResponse.loading());
    var param = {
      "LogType": "APP_CRASH_LOG",
      "UserId": await UserSession().getUserId(),
      "LogDetails": json.encode(errorVm)
    };
    _myRepo.crashApiSubmit(params: param).then((value) {
      syncCrashApiSubmit(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      syncCrashApiSubmit(ApiResponse.error(error.toString()));
      AppLog().errLog(
          err: "fetch recommendation ${error.toString()}",
          stackTrace: stackTrace);
    });
  }
}
