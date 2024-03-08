import '../../extension/logger_extension.dart';

class PgResponseModel {
  int? msgcode;
  List<PgModel>? data;
  String? msg;
  int? status;
  String? message;

  PgResponseModel(
      {this.msgcode, this.data, this.msg, this.status, this.message});

  PgResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      msgcode = json['msgcode'];
      if (json['data'] != null) {
        data = <PgModel>[];
        json['data'].forEach((v) {
          data!.add(PgModel.fromJson(v));
        });
      }
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
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class PgModel {
  String? desc;
  int? displaySeq;
  String? image;
  String? imagePath;
  bool? isDefault;
  String? key;
  int? pGListingId;
  String? payOption;
  String? pgType;
  String? title;

  PgModel(
      {this.desc,
      this.displaySeq,
      this.image,
      this.imagePath,
      this.isDefault,
      this.key,
      this.pGListingId,
      this.payOption,
      this.pgType,
      this.title});

  PgModel.fromJson(Map<String, dynamic> json) {
    try {
      desc = json['Desc'];
      displaySeq = json['DisplaySeq'];
      image = json['Image'];
      imagePath = json['Image_path'];
      isDefault = json['IsDefault'];
      key = json['Key'];
      pGListingId = json['PGListingId'];
      payOption = json['PayOption'];
      pgType = json['PgType'];
      title = json['Title'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Desc'] = desc;
    data['DisplaySeq'] = displaySeq;
    data['Image'] = image;
    data['Image_path'] = imagePath;
    data['IsDefault'] = isDefault;
    data['Key'] = key;
    data['PGListingId'] = pGListingId;
    data['PayOption'] = payOption;
    data['PgType'] = pgType;
    data['Title'] = title;
    return data;
  }
}
