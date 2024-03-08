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
  String? host;
  String? origin;
  String? connection;
  String? referer;
  String? secFetchDest;
  String? secFetchMode;
  String? secFetchSite;
  String? deviceId;
  String? deviceDensityType;
  String? deviceName;
  String? networkInfo;
  String? deviceWidth;
  String? deviceOsInfo;
  String? deviceHeight;
  String? deviceDensity;
  String? appVersionCode;

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
      this.host,
      this.origin,
      this.connection,
      this.referer,
      this.secFetchDest,
      this.secFetchMode,
      this.secFetchSite,
      this.deviceId,
      this.deviceDensityType,
      this.deviceName,
      this.networkInfo,
      this.deviceWidth,
      this.deviceOsInfo,
      this.deviceHeight,
      this.deviceDensity,
      this.appVersionCode});

  Headers.fromJson(Map<String, dynamic> json) {
    userAgent = json['User-Agent'];
    accept = json['Accept'];
    acceptLanguage = json['Accept-Language'];
    acceptEncoding = json['Accept-Encoding'];
    accessToken = json['access_token'];
    rtoken = json['rtoken'];
    browserId = json['browser-id'];
    appType = json['App-Type'];
    appVersion = json['App-Version'];
    pincode = json['Pincode'];
    authorization = json['Authorization'];

    contentType = json['Content-Type'];
    host = json['Host'];
    origin = json['Origin'];
    connection = json['Connection'];
    referer = json['Referer'];
    secFetchDest = json['Sec-Fetch-Dest'];
    secFetchMode = json['Sec-Fetch-Mode'];
    secFetchSite = json['Sec-Fetch-Site'];
    deviceId = json['Device-Id'];
    deviceDensityType = json['Device-Density-Type'];
    deviceName = json['Device-Name'];
    networkInfo = json['Network-Info'];
    deviceWidth = json['Device-Width'];
    deviceOsInfo = json['Device-Os-Info'];
    deviceHeight = json['Device-Height'];
    deviceDensity = json['Device-Density'];
    appVersionCode = json['App-Version-Code'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    if (userAgent != null) {
      data['User-Agent'] = userAgent ?? "";
    }
    if (accept != null) {
      data['Accept'] = accept ?? "";
    }
    if (acceptLanguage != null) {
      data['Accept-Language'] = acceptLanguage ?? "";
    }
    if (acceptEncoding != null) {
      data['Accept-Encoding'] = acceptEncoding ?? "";
    }
    if (accessToken != null) {
      data['access_token'] = accessToken ?? "";
    }
    if (rtoken != null) {
      data['rtoken'] = rtoken ?? "";
    }
    if (browserId != null) {
      data['browser-id'] = browserId ?? "";
    }
    if (appType != null) {
      data['App-Type'] = appType ?? "";
    }
    if (appVersion != null) {
      data['App-Version'] = appVersion ?? "";
    }
    if (pincode != null) {
      data['Pincode'] = pincode ?? "";
    }
    if (authorization != null) {
      data['Authorization'] = authorization ?? "";
    }

    if (contentType != null) {
      data['Content-Type'] = contentType ?? "";
    }
    if (host != null) {
      data['Host'] = host ?? "";
    }
    if (origin != null) {
      data['Origin'] = origin ?? "";
    }
    if (connection != null) {
      data['Connection'] = connection ?? "";
    }
    if (referer != null) {
      data['Referer'] = referer ?? "";
    }
    if (secFetchDest != null) {
      data['Sec-Fetch-Dest'] = secFetchDest ?? "";
    }
    if (secFetchMode != null) {
      data['Sec-Fetch-Mode'] = secFetchMode ?? "";
    }
    if (secFetchSite != null) {
      data['Sec-Fetch-Site'] = secFetchSite ?? "";
    }
    if (deviceId != null) {
      data['Device-Id'] = deviceId ?? "";
    }
    if (deviceDensityType != null) {
      data['Device-Density-Type'] = deviceDensityType ?? '';
    }
    if (deviceName != null) {
      data['Device-Name'] = deviceName ?? '';
    }
    if (networkInfo != null) {
      data['Network-Info'] = networkInfo ?? '';
    }
    if (deviceWidth != null) {
      data['Device-Width'] = deviceWidth ?? '';
    }
    if (deviceOsInfo != null) {
      data['Device-Os-Info'] = "$deviceOsInfo";
    }
    if (deviceHeight != null) {
      data['Device-Height'] = "$deviceHeight";
    }
    if (deviceDensity != null) {
      data['Device-Density'] = "$deviceDensity";
    }
    if (appVersionCode != null) {
      data['App-Version-Code'] = "$appVersionCode";
    }
    return data;
  }
}
