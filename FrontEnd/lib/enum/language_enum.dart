import 'package:flutter/material.dart';

import '../extension/logger_extension.dart';

enum LanguageEnum {
  english('1', "English", Locale("en")),
  malay('3', "Malay", Locale("ms"));

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
