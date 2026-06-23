import 'package:dbnus/core/services/value_handler.dart';

class RazorpayMerchantDetails {
  String? amount;
  String? amountDue;
  String? amountPaid;
  String? attempts;
  String? createdAt;
  String? currency;
  String? entity;
  String? id;
  String? offerId;
  String? receipt;
  String? status;
  String? httpCode;
  String? razorpayKey;

  RazorpayMerchantDetails(
      {this.amount,
      this.amountDue,
      this.amountPaid,
      this.attempts,
      this.createdAt,
      this.currency,
      this.entity,
      this.id,
      this.offerId,
      this.receipt,
      this.status,
      this.httpCode,
      this.razorpayKey});

  RazorpayMerchantDetails.fromJson(Map<String, dynamic> json) {
    amount = ValueHandler.stringify(json['amount']);
    amountDue = ValueHandler.stringify(json['amount_due']);
    amountPaid = ValueHandler.stringify(json['amount_paid']);
    attempts = ValueHandler.stringify(json['attempts']);
    createdAt = ValueHandler.stringify(json['created_at']);
    currency = ValueHandler.stringify(json['currency']);
    entity = ValueHandler.stringify(json['entity']);
    id = ValueHandler.stringify(json['id']);
    offerId = ValueHandler.stringify(json['offer_id']);
    receipt = ValueHandler.stringify(json['receipt']);
    status = ValueHandler.stringify(json['status']);
    httpCode = ValueHandler.stringify(json['http_code']);
    razorpayKey = ValueHandler.stringify(json['razorpay_key']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['amount_due'] = amountDue;
    data['amount_paid'] = amountPaid;
    data['attempts'] = attempts;
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['entity'] = entity;
    data['id'] = id;
    data['offer_id'] = offerId;
    data['receipt'] = receipt;
    data['status'] = status;
    data['http_code'] = httpCode;
    data['razorpay_key'] = razorpayKey;
    return data;
  }
}
