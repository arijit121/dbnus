import '../../extension/logger_extension.dart';

class UploadPrescriptionResponse {
  int? msgcode;
  String? msg;
  String? message;
  int? status;
  Data? data;

  UploadPrescriptionResponse(
      {this.msgcode, this.msg, this.message, this.status, this.data});

  UploadPrescriptionResponse.fromJson(Map<String, dynamic> json) {
    try {
      msgcode = json['msgcode'];
      msg = json['msg'];
      message = json['message'];
      status = json['status'];
      data = json['data'] != null ? Data.fromJson(json['data']) : null;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msgcode'] = msgcode;
    data['msg'] = msg;
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? uploadedFileName;

  Data({this.uploadedFileName});

  Data.fromJson(Map<String, dynamic> json) {
    try {
      uploadedFileName = json['UploadedFileName'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UploadedFileName'] = uploadedFileName;
    return data;
  }
}
