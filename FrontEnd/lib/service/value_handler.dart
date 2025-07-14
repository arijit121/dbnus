import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' deferred as crypto;
import 'package:encrypt/encrypt.dart' deferred as encrypt;
import 'package:intl/intl.dart';

import '../config/app_config.dart' deferred as app_config;
import '../extension/logger_extension.dart';

class ValueHandler {
  int generateTimestamp() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  DateTime? dateTimeFromTimestamp({required int? timestamp}) {
    if (ValueHandler().isNonZeroNumericValue(timestamp)) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
      return date;
    }
    return null;
  }

  String? stringify(var value) {
    try {
      if (value == null || value.toString().toLowerCase() == "null") {
        return null;
      } else {
        return "$value";
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  int? intify(var value) {
    try {
      if (value == null ||
          value.toString().toLowerCase() == "null" ||
          value.toString().trim().isEmpty) {
        return null;
      } else {
        return num.parse("$value").toInt();
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  num? numify(var value) {
    try {
      if (value == null ||
          value.toString().toLowerCase() == "null" ||
          value.toString().trim().isEmpty) {
        return null;
      } else {
        return num.parse("$value");
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  bool? boolify(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value == null) return null;

    String str = value.toString().toLowerCase().trim();
    if (isTextNotEmptyOrNull(str)) {
      return (str == "true" || str == "1");
    }
    return null;
  }

  String dateTimeFormatter({required DateTime dateTime, String? newPattern}) {
    String date = DateFormat(newPattern ?? "yyyy-MM-dd").format(dateTime);
    return date;
  }

  /// Fri, 12 may 2023
  String? dateTimeEEEDMMMYYYY({String? dateTime}) {
    try {
      if (dateTime?.isNotEmpty == true) {
        String date =
            DateFormat("EEE, dd MMM yyyy").format(DateTime.parse(dateTime!));
        return date;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  ///  12 may 2023
  String? dateTimeEEEDMMMYYYY2({String? dateTime}) {
    try {
      if (dateTime?.isNotEmpty == true) {
        String date =
            DateFormat("dd MMM yyyy").format(DateTime.parse(dateTime!));
        return date;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  /// 9th Sept, 2021
  String? dateTimeDthMMMYYYY({String? dateTime}) {
    try {
      if (dateTime?.isNotEmpty == true) {
        DateTime tempDateTime = DateTime.parse(dateTime!);
        String date = DateFormat("MMMM, yyyy").format(tempDateTime);
        return "${tempDateTime.day}${_getDayOfMonthSuffix(tempDateTime.day)} $date";
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  String _getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Duration dateTimeCompare(
      {required String? dateTime, DateTime? compareWithDate}) {
    try {
      if (dateTime?.isNotEmpty == true) {
        DateTime date = DateTime.parse(dateTime!);
        Duration duration = date.difference(compareWithDate ?? DateTime.now());
        return duration;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return const Duration();
  }

  String? timeOfDayParser({String? timeOfDayString}) {
    try {
      if (timeOfDayString == null || timeOfDayString.trim().isEmpty) {
        return null;
      }

      // Parse the 24-hour format input
      DateTime parsedTime =
      DateFormat.Hm().parse(timeOfDayString); // e.g., "10:30"

      // Format to 12-hour format with AM/PM
      return DateFormat.jm().format(parsedTime); // e.g., "10:30 AM"
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  DateTime? stringToDateTime({String? dateTime, String? pattern}) {
    try {
      if (dateTime != null) {
        return DateFormat(pattern ?? "yyyy-MM-dd").parse(dateTime);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  String skey = "SSSK#08#@93@*(-**SSSK@9.#@92@";

  Future<String?> customEncryption({required String value}) async {
    try {
      String encodedKey = base64Url.encode(utf8.encode(skey)).substring(0, 32);
      await encrypt.loadLibrary();
      final key = encrypt.Key.fromUtf8(encodedKey);
      final iv = encrypt.IV.fromUtf8(skey.substring(0, 16));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(value, iv: iv);
      return encrypted.base64;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<String?> customDecryption({required String encodedValue}) async {
    try {
      String encodedKey = base64Url.encode(utf8.encode(skey)).substring(0, 32);
      await encrypt.loadLibrary();
      final key = encrypt.Key.fromUtf8(encodedKey);
      final iv = encrypt.IV.fromUtf8(skey.substring(0, 16));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypt.Encrypted.fromBase64(encodedValue);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  String? stringDateTimeFormatter(
      {required String dateTime, String? newPattern}) {
    try {
      var date1 = DateTime.parse(dateTime);
      String date = DateFormat(newPattern ?? "yyyy-MM-dd").format(date1);
      return date;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  bool isTextNotEmptyOrNull(dynamic src) {
    var value = src != null &&
        src.toString().isNotEmpty &&
        src != "null" &&
        src != "Null" &&
        src != "NULL" &&
        src != "";
    return value;
  }

  setNullTextToZero(src) {
    return isTextNotEmptyOrNull(src) ? src : 0;
  }

  String setNullTextToBlank(final String input) {
    return !isTextNotEmptyOrNull(input) ? "" : input;
  }

  String? setNullBlankTextToNullAbleString(final String? input) {
    return !isTextNotEmptyOrNull(input) ? null : input;
  }

  bool isNonZeroNumericValue(dynamic txt) {
    String? res = stringify(txt);
    if (isTextNotEmptyOrNull(res)) {
      try {
        return num.parse(res!) > 0;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  double dp({required double val, required int places}) {
    String temp = val.toStringAsFixed(places);
    return double.parse(temp);
  }

  String stringToBase64({required String value}) {
    return base64Encode(utf8.encode(value));
  }

  String base64ToString({required String encoded}) {
    return utf8.decode(base64Decode(encoded));
  }

  String uriEncodeForm({required Map<String, dynamic> body}) {
    List parts = [];
    body.forEach((key, value) {
      parts.add('$key=${value ?? ""}');
    });
    String formData = parts.join('&');
    return formData;
  }

  Future<Map<String, String>> httpPost(
      {required String accessToken,
      required String postXml,
      String? tag}) async {
    /*OLD API XML Call*/
    await Future.wait([crypto.loadLibrary(), app_config.loadLibrary()]);
    AppLog.i(postXml, tag: "${tag ?? ""} PostXml");
    AppLog.i(accessToken, tag: "${tag ?? ""} AccessToken");

    String base64Xml = encryptXmlRequest(postXml);
    var rng = Random();
    int randomHash = rng.nextInt(90000000) + 10000000;

    Map<String, String> postParams = {};
    postParams["content"] = base64Xml;
    postParams["accessKey"] =
        ((await app_config.AppConfig().getDeviceId()) ?? "");
    postParams["HTTP_SIGNATURE"] =
            '${crypto.Hmac(crypto.md5, utf8.encode(accessToken)).convert(utf8.encode("$postXml$randomHash"))}'
        // hmacDigest("$postXml$randomHash", accessToken, crypto.md5)
        ;
    postParams["HTTP_RANDOM_HASH"] = randomHash.toString();
    /*to manage static access token 13-06-2018*/
    postParams["VersionCode"] =
        await app_config.AppConfig().getAppVersionCode() ?? "";

    return postParams;
  }

  String encryptXmlRequest(String input) {
    if (input.isEmpty) return "";
    try {
      String urlEncodedData = Uri.encodeComponent(input);
      List<int> data = utf8.encode(urlEncodedData);
      return base64Encode(data);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return "";
    }
  }

  bool isHtml(String text) {
    final RegExp htmlRegExp = RegExp(r'<[^>]*>');
    return htmlRegExp.hasMatch(text);
  }

  String parseHtmlToText(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  /// *
  /// todo
  ///  @Note Please don't change this encryption algo as it same as in Phonegap app
  ///  msg, key , algo
  ///  return different types of hmac encryption in md5
  ///  Link: http://www.supermind.org/blog/1102/generating-hmac-md5-sha1-sha256-etc-in-java
  // String hmacDigest(String msg, String keyString, Hash algo) {
  //   var key = utf8.encode(keyString);
  //   var bytes = utf8.encode(msg);
  //
  //   var hmacSha256 = Hmac(algo, key);
  //   var digest = hmacSha256.convert(bytes);
  //
  //   return '$digest';
  // }

  String frontCapitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
