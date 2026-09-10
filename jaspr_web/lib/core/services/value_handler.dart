import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';

import '../config/app_config.dart';
import '../../shared/extensions/logger_extension.dart';

class ValueHandler {
  static int generateTimestamp() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  static DateTime? dateTimeFromTimestamp({required int? timestamp}) {
    if (ValueHandler.isNonZeroNumericValue(timestamp)) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
      return date;
    }
    return null;
  }

  static String? stringify(var value) {
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

  static int? intify(var value) {
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

  static num? numify(var value) {
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

  static bool? boolify(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value == null) return null;

    String str = value.toString().toLowerCase().trim();
    if (ValueHandler.isTextNotEmptyOrNull(str)) {
      return (str == "true" || str == "1");
    }
    return null;
  }

  static String dateTimeFormatter({required DateTime dateTime, String? newPattern}) {
    String date = DateFormat(newPattern ?? "yyyy-MM-dd").format(dateTime);
    return date;
  }

  static String? dateTimeEEEDMMMYYYY({String? dateTime}) {
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

  static String? dateTimeEEEDMMMYYYY2({String? dateTime}) {
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

  static String? dateTimeDthMMMYYYY({String? dateTime}) {
    try {
      if (dateTime?.isNotEmpty == true) {
        DateTime tempDateTime = DateTime.parse(dateTime!);
        String date = DateFormat("MMMM, yyyy").format(tempDateTime);
        return "${tempDateTime.day}${ValueHandler._getDayOfMonthSuffix(tempDateTime.day)} $date";
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static String _getDayOfMonthSuffix(int dayNum) {
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

  static Duration dateTimeCompare({required String? dateTime, DateTime? compareWithDate}) {
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

  static String? timeOfDayParser({String? timeOfDayString}) {
    try {
      if (timeOfDayString == null || timeOfDayString.trim().isEmpty) {
        return null;
      }
      DateTime parsedTime = DateFormat.Hm().parse(timeOfDayString);
      return DateFormat.jm().format(parsedTime);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static DateTime? stringToDateTime({String? dateTime, String? pattern}) {
    try {
      if (dateTime != null) {
        return DateFormat(pattern ?? "yyyy-MM-dd").parse(dateTime);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static String skey = "SSSK#08#@93@*(-**SSSK@9.#@92@";

  static Future<String?> customEncryption({required String value}) async {
    try {
      String encodedKey =
          base64Url.encode(utf8.encode(ValueHandler.skey)).substring(0, 32);
      final key = encrypt.Key.fromUtf8(encodedKey);
      final iv = encrypt.IV.fromUtf8(ValueHandler.skey.substring(0, 16));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(value, iv: iv);
      return encrypted.base64;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static Future<String?> customDecryption({required String encodedValue}) async {
    try {
      String encodedKey =
          base64Url.encode(utf8.encode(ValueHandler.skey)).substring(0, 32);
      final key = encrypt.Key.fromUtf8(encodedKey);
      final iv = encrypt.IV.fromUtf8(ValueHandler.skey.substring(0, 16));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypt.Encrypted.fromBase64(encodedValue);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static String? stringDateTimeFormatter({required String dateTime, String? newPattern}) {
    try {
      var date1 = DateTime.parse(dateTime);
      String date = DateFormat(newPattern ?? "yyyy-MM-dd").format(date1);
      return date;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static bool isTextNotEmptyOrNull(dynamic src) {
    var value = src != null &&
        src.toString().isNotEmpty &&
        src != "null" &&
        src != "Null" &&
        src != "NULL" &&
        src != "";
    return value;
  }

  static setNullTextToZero(src) {
    return ValueHandler.isTextNotEmptyOrNull(src) ? src : 0;
  }

  static String setNullTextToBlank(final String input) {
    return !ValueHandler.isTextNotEmptyOrNull(input) ? "" : input;
  }

  static String? setNullBlankTextToNullAbleString(final String? input) {
    return !ValueHandler.isTextNotEmptyOrNull(input) ? null : input;
  }

  static bool isNonZeroNumericValue(dynamic txt) {
    String? res = ValueHandler.stringify(txt);
    if (ValueHandler.isTextNotEmptyOrNull(res)) {
      try {
        return num.parse(res!) > 0;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static double dp({required double val, required int places}) {
    String temp = val.toStringAsFixed(places);
    return double.parse(temp);
  }

  static String stringToBase64({required String value}) {
    return base64Encode(utf8.encode(value));
  }

  static String base64ToString({required String encoded}) {
    return utf8.decode(base64Decode(encoded));
  }

  static String uriEncodeForm({required Map<String, dynamic> body}) {
    List parts = [];
    body.forEach((key, value) {
      parts.add('$key=${value ?? ""}');
    });
    String formData = parts.join('&');
    return formData;
  }

  static Future<Map<String, String>> httpPost({
    required String accessToken,
    required String postXml,
    String? tag,
  }) async {
    AppLog.i(postXml, tag: "${tag ?? ""} PostXml");
    AppLog.i(accessToken, tag: "${tag ?? ""} AccessToken");

    String base64Xml = ValueHandler.encryptXmlRequest(postXml);
    var rng = Random();
    int randomHash = rng.nextInt(90000000) + 10000000;

    Map<String, String> postParams = {};
    postParams["content"] = base64Xml;
    postParams["accessKey"] = ((await AppConfig().getDeviceId()) ?? "");
    postParams["HTTP_SIGNATURE"] =
        '${crypto.Hmac(crypto.md5, utf8.encode(accessToken)).convert(utf8.encode("$postXml$randomHash"))}';
    postParams["HTTP_RANDOM_HASH"] = randomHash.toString();
    postParams["VersionCode"] = await AppConfig().getAppVersionCode() ?? "";

    return postParams;
  }

  static String encryptXmlRequest(String input) {
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

  static bool isHtml(String text) {
    final RegExp htmlRegExp = RegExp(r'<[^>]*>');
    return htmlRegExp.hasMatch(text);
  }

  static String parseHtmlToText(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  static String frontCapitalize(String s) =>
      s[0].toUpperCase() + s.substring(1);

  static bool canBeJsonDecoded(String value) {
    try {
      json.decode(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  static num? calculateAverage(List<num> numbers) {
    try {
      if (numbers.isEmpty) return null;
      num sum = numbers.fold<num>(0, (a, b) => a + b);
      if (sum == 0) return null;
      return sum / numbers.length;
    } catch (e) {
      return null;
    }
  }
}
