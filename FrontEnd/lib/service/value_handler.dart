import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import '../service/context_service.dart';
import 'package:intl/intl.dart';

import '../extension/logger_extension.dart';

class ValueHandler {
  String? stringify(var value) {
    if (value == null || value.toString().toLowerCase() == "null") {
      return null;
    } else {
      return "$value";
    }
  }

  int? intify(var value) {
    try {
      if (value == null ||
          value.toString().toLowerCase() == "null" ||
          value.toString().trim().isEmpty) {
        return null;
      } else {
        return int.parse("$value");
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

  bool? boolify(var value) {
    if (value is int) {
      return value == 1;
    } else if (value.toString().toLowerCase() == "true" ||
        value.toString().toLowerCase() == "false") {
      return value.toString().toLowerCase() == "true";
    }

    return null;
  }

  String? dateTimeFormatter({required DateTime? dateTime, String? newPattern}) {
    try {
      if (dateTime != null) {
        String date = DateFormat(newPattern ?? "yyyy-MM-dd").format(dateTime);
        return date;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
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

  Duration dateTimeCompare({String? dateTime, DateTime? compareWithDate}) {
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
      if (timeOfDayString != null) {
        TimeOfDay timeOfDay = TimeOfDay(
            hour: int.parse(timeOfDayString.split(":")[0]),
            minute: int.parse(timeOfDayString.split(":")[1]));
        timeOfDay.toString();
        return timeOfDay.format(CurrentContext().context);
      }
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

  String skey = "GenuSK#08#@93@*(-**GenuSK@9.#@92@";

  String? customEncryption({required String value}) {
    try {
      String encodedKey = base64Url.encode(utf8.encode(skey)).substring(0, 32);
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

  String? customDecryption({required String encodedValue}) {
    try {
      String encodedKey = base64Url.encode(utf8.encode(skey)).substring(0, 32);
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
        src != "";
    return value;
  }

  double dp({required double val, required int places}) {
    String temp = val.toStringAsFixed(places);
    return double.parse(temp);
  }

  String uriEncodeForm({required Map<String, dynamic> body}) {
    List parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value ?? "")}');
    });
    String formData = parts.join('&');
    return formData;
  }
}
