import '../../extension/logger_extension.dart';
import 'service_model.dart';

class ServiceDetailsModel {
  int? msgcode;
  Data? data;
  String? msg;
  int? status;
  String? message;

  ServiceDetailsModel(
      {this.msgcode, this.data, this.msg, this.status, this.message});

  ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
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
  ServiceModel? items;

  Data({this.items});

  Data.fromJson(Map<String, dynamic> json) {
    try {
      items = json['Items'] != null
          ? ServiceModel.fromDetailsJson(json['Items'])
          : null;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['Items'] = items!.toJson();
    }
    return data;
  }
}
