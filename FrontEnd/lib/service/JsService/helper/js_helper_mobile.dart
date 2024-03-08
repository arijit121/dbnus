class JSHelper {
  Future paytmLoadScript(
    String txnToken,
    String orderId,
    String amount,
    String mid,
  ) async {
    return "";
  }

  Future<void> downloadFile(
      {required String url, required String name}) async {}

  Future<void> changeUrlJs({required String path}) async {}

  Future<void> onCheckoutPhonePe() async {}

  Future getCurrentUrlElementByIdFun(String iframeId) async {
    return null;
  }

  String getPlatformFromJS() {
    return "";
  }

  String getBaseUrlFromJS() {
    return "";
  }

  Future<String> callOpenTab() {
    return Future.value('');
  }

  void reDirectToUrl(String reDirectUrl) {}

  Future<void> setVolume(double volume) async {}

  Future<String> callJSPromise() async {
    return "";
  }

  Future<String?> getDeviceId() async {
    return null;
  }

  void submitForm(actionUrl, String obj, String id) {}
}
