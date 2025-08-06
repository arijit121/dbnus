class WebViewPaymentGatewayModel {
  String paymentLink;
  String redirectLink;
  String transactionId;
  String? payType;
  String? transactionType;
  num? walletDeduction;
  String? failedRedirectLink;

  WebViewPaymentGatewayModel(
      {required this.paymentLink,
      required this.redirectLink,
      required this.transactionId,
      this.payType,
      this.transactionType,
      this.walletDeduction,
      this.failedRedirectLink});

  factory WebViewPaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    return WebViewPaymentGatewayModel(
      paymentLink: json['paymentLink'],
      redirectLink: json['redirectLink'],
      transactionId: json['transactionId'],
      payType: json['payType'],
      transactionType: json['transactionType'],
      walletDeduction: json['walletDeduction'],
      failedRedirectLink: json['failedRedirectLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentLink': paymentLink,
      'redirectLink': redirectLink,
      'transactionId': transactionId,
      'payType': payType,
      'transactionType': transactionType,
      'walletDeduction': walletDeduction,
      'failedRedirectLink': failedRedirectLink,
    };
  }
}
