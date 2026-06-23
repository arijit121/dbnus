class Headers {
  String? userAgent;
  String? accept;
  String? acceptLanguage;
  String? acceptEncoding;
  String? accessToken;
  String? rtoken;
  String? browserId;
  String? appType;
  String? appVersion;
  String? pincode;
  String? authorization;
  String? contentType;
  String? deviceName;
  String? networkInfo;
  String? deviceWidth;
  String? deviceOsInfo;
  String? deviceHeight;
  String? deviceDensity;
  String? appVersionCode;
  String? deviceId;
  String? deviceDensityType;
  String? deviceIpV6;
  String? deviceIpV4;

  Headers(
      {this.userAgent,
      this.accept,
      this.acceptLanguage,
      this.acceptEncoding,
      this.accessToken,
      this.rtoken,
      this.browserId,
      this.appType,
      this.appVersion,
      this.pincode,
      this.authorization,
      this.contentType,
      this.deviceIpV6,
      this.deviceIpV4,
      this.deviceId,
      this.deviceDensityType,
      this.deviceName,
      this.networkInfo,
      this.deviceWidth,
      this.deviceOsInfo,
      this.deviceHeight,
      this.deviceDensity,
      this.appVersionCode});

  Map<String, String> toJson() {
    final Map<String, dynamic> data = {};

    data['User-Agent'] = userAgent;
    data['Accept'] = accept;
    data['Accept-Language'] = acceptLanguage;
    data['Accept-Encoding'] = acceptEncoding;
    data['access_token'] = accessToken;
    data['rtoken'] = rtoken;
    data['browser-id'] = browserId;
    data['App-Type'] = appType;
    data['App-Version'] = appVersion;
    data['Pincode'] = pincode;
    data['Authorization'] = authorization;
    data['Content-Type'] = contentType;
    data['device-ipv6'] = deviceIpV6;
    data['device-ipv4'] = deviceIpV4;
    data['Device-Id'] = deviceId;
    data['Device-Density-Type'] = deviceDensityType;
    data['Device-Name'] = deviceName;
    data['Network-Info'] = networkInfo;
    data['Device-Width'] = deviceWidth;
    data['Device-Os-Info'] = deviceOsInfo;
    data['Device-Height'] = deviceHeight;
    data['Device-Density'] = deviceDensity;
    data['App-Version-Code'] = appVersionCode;

    data.removeWhere((key, value) => value == null);
    Map<String, String> result =
        data.map((key, value) => MapEntry(key, (value ?? "").toString()));
    return result;
  }
}
