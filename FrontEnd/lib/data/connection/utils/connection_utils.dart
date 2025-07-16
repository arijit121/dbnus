import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../extension/logger_extension.dart';

import '../../../service/value_handler.dart' deferred as value_handler;
import '../../../storage/local_preferences.dart';
import '../../api_client/imp/api_repo_imp.dart' deferred as api_repo_imp;
import '../../api_client/repo/api_repo.dart' deferred as api_repo;
import '../connection_status.dart' deferred as connection_status;

class ConnectionUtils {
  Future<void> setIpV4(String ipV4) async {
    await LocalPreferences()
        .setString(key: LocalPreferences.ssIpV4, value: ipV4);
  }

  Future<String?> getIpV4() async {
    String? ssIpV4 =
        await LocalPreferences().getString(key: LocalPreferences.ssIpV4);
    await value_handler.loadLibrary();
    if (!value_handler.ValueHandler.isTextNotEmptyOrNull(ssIpV4)) {
      ssIpV4 = await fetchWifiIpV4();
      if (value_handler.ValueHandler.isTextNotEmptyOrNull(ssIpV4)) {
        await setIpV4(ssIpV4!);
      }
    }
    return ssIpV4;
  }

  Future<void> setIpV6(String ipV6) async {
    await LocalPreferences()
        .setString(key: LocalPreferences.ssIpV6, value: ipV6);
  }

  Future<String?> getIpV6() async {
    String? ssIpV6 =
        await LocalPreferences().getString(key: LocalPreferences.ssIpV6);
    await value_handler.loadLibrary();
    if (!value_handler.ValueHandler.isTextNotEmptyOrNull(ssIpV6)) {
      ssIpV6 = await fetchWifiIpV6();
      if (value_handler.ValueHandler.isTextNotEmptyOrNull(ssIpV6)) {
        await setIpV6(ssIpV6!);
      }
    }
    return ssIpV6;
  }

  Future<String?> fetchWifiIpV4() async {
    final info = NetworkInfo();
    String? wifiIpV4;
    try {
      wifiIpV4 = kIsWeb ? null : await info.getWifiIP();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return wifiIpV4 ??
        await _getIpFromInternet(
            tag: 'WifiIpV4', uri: 'https://api.ipify.org?format=json');
  }

  Future<String?> fetchWifiIpV6() async {
    final info = NetworkInfo();
    String? wifiIpV6;
    try {
      wifiIpV6 = kIsWeb ? null : await info.getWifiIPv6();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return wifiIpV6 ??
        await _getIpFromInternet(
            tag: 'WifiIpV6', uri: 'https://api6.ipify.org?format=json');
  }

  Future<String?> _getIpFromInternet(
      {required String tag, required String uri}) async {
    await Future.wait([
      connection_status.loadLibrary(),
      api_repo.loadLibrary(),
      api_repo_imp.loadLibrary()
    ]);
    final connectionStatus = connection_status.ConnectionStatus.getInstance;
    bool onlineStatus = await connectionStatus.checkConnection();
    if (onlineStatus) {
      final response = await api_repo
          .ApiEngine
          .callApi(tag: tag, uri: uri, method: api_repo_imp.Method.get);
      if (response?.responseString != null && response?.statusCode == 200) {
        var v = json.decode(response?.responseString ?? "");
        return v['ip'];
      }
    }
    return null;
  }
}
