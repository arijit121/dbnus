import 'package:dbnus/shared/extensions/logger_extension.dart';

class PaytmMerchantDetails {
  String? actionUrl;
  String? mode;
  String? amount;
  bool? authenticated;
  String? callbackurl;
  bool? isPromoCodeValid;
  String? isValidChecksum;
  String? mid;
  String? orderId;
  ResultInfo? resultInfo;
  String? txnToken;

  PaytmMerchantDetails(
      {this.actionUrl,
      this.mode,
      this.amount,
      this.authenticated,
      this.callbackurl,
      this.isPromoCodeValid,
      this.isValidChecksum,
      this.mid,
      this.orderId,
      this.resultInfo,
      this.txnToken});

  PaytmMerchantDetails.fromJson(Map<String, dynamic> json) {
    try {
      actionUrl = json['ActionUrl'];
      mode = json['Mode'];
      amount = json['amount'];
      authenticated = json['authenticated'];
      callbackurl = json['callbackurl'];
      isPromoCodeValid = json['isPromoCodeValid'];
      isValidChecksum = json['isValidChecksum'];
      mid = json['mid'];
      orderId = json['orderId'];
      resultInfo = json['resultInfo'] != null
          ? ResultInfo.fromJson(json['resultInfo'])
          : null;
      txnToken = json['txnToken'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ActionUrl'] = actionUrl;
    data['Mode'] = mode;
    data['amount'] = amount;
    data['authenticated'] = authenticated;
    data['callbackurl'] = callbackurl;
    data['isPromoCodeValid'] = isPromoCodeValid;
    data['isValidChecksum'] = isValidChecksum;
    data['mid'] = mid;
    data['orderId'] = orderId;
    if (resultInfo != null) {
      data['resultInfo'] = resultInfo!.toJson();
    }
    data['txnToken'] = txnToken;
    return data;
  }
}

class ResultInfo {
  String? resultCode;
  String? resultMsg;
  String? resultStatus;

  ResultInfo({this.resultCode, this.resultMsg, this.resultStatus});

  ResultInfo.fromJson(Map<String, dynamic> json) {
    try {
      resultCode = json['resultCode'];
      resultMsg = json['resultMsg'];
      resultStatus = json['resultStatus'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCode'] = resultCode;
    data['resultMsg'] = resultMsg;
    data['resultStatus'] = resultStatus;
    return data;
  }
}
