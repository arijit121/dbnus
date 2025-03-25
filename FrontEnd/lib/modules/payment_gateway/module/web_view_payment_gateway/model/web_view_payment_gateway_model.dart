class WebViewPaymentGatewayModel {
  String paymentLink;
  String redirectLink;
  String transactionId;
  String? payType;
  num? walletDeduction;
  String? failedRedirectLink;
  Duration? timeOut;

  WebViewPaymentGatewayModel(
      {required this.paymentLink,
      required this.redirectLink,
      required this.transactionId,
      this.payType,
      this.walletDeduction,
      this.failedRedirectLink,
      this.timeOut});

  factory WebViewPaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    return WebViewPaymentGatewayModel(
      paymentLink: json['paymentLink'],
      redirectLink: json['redirectLink'],
      transactionId: json['transactionId'],
      payType: json['payType'],
      walletDeduction: json['walletDeduction'],
      failedRedirectLink: json['failedRedirectLink'],
      timeOut: json['timeOut'] != null
          ? Duration(milliseconds: json['timeOut'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentLink': paymentLink,
      'redirectLink': redirectLink,
      'transactionId': transactionId,
      'payType': payType,
      'walletDeduction': walletDeduction,
      'failedRedirectLink': failedRedirectLink,
      'timeOut': timeOut?.inMilliseconds,
    };
  }
}
