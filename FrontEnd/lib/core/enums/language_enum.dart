import 'package:flutter/material.dart';

import 'package:dbnus/core/extensions/logger_extension.dart';

enum LanguageEnum {
  english('1', "English", Locale("en")),
  spanish('2', "Spanish", Locale("es"));

  final String value, name;
  final Locale locale;

  const LanguageEnum(this.value, this.name, this.locale);

  static LanguageEnum? getLanguageFromLocale({required Locale? locale}) {
    try {
      return LanguageEnum.values.firstWhere((language) =>
          language.locale.toLanguageTag() == locale?.toLanguageTag());
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }
}
