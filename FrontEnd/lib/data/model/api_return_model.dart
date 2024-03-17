import '../../extension/logger_extension.dart';

class ApiReturnModel {
  int? statusCode;
  String? responseString;

  ApiReturnModel({this.statusCode, this.responseString});

  ApiReturnModel.fromJson(Map<String, dynamic> json) {
    try {
      statusCode = json['statusCode'];
      responseString = json['responseString'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['responseString'] = responseString;
    return data;
  }
}
