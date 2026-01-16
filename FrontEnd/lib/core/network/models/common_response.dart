import 'package:dbnus/core/extensions/logger_extension.dart';

class CommonResponse {
  int? msgcode;
  Data? data;
  String? msg;
  int? status;
  String? message;

  CommonResponse(
      {this.msgcode, this.data, this.msg, this.status, this.message});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    try {
      msgcode = json['msgcode'];
      data = json['data'] != null ? Data.fromJson(json['data']) : null;
      msg = json['msg'];
      status = json['status'];
      message = json['message'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msgcode'] = msgcode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class Data {
  int? returnStatus;

  Data({this.returnStatus});

  Data.fromJson(Map<String, dynamic> json) {
    try {
      returnStatus = json['ReturnStatus'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ReturnStatus'] = returnStatus;
    return data;
  }
}
