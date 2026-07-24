import 'package:dbnus/core/services/context_service.dart';
import 'package:dbnus/core/services/value_handler.dart'
    deferred as value_handler;
import 'package:dbnus/core/storage/local_preferences.dart'
    deferred as local_preferences;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbnus/core/enums/language_enum.dart';
import 'package:dbnus/core/localization/bloc/localization_bloc.dart';

class LocalizationUtils {
  static List<Locale> supportedLocales =
      LanguageEnum.values.map((language) => language.locale).toList();

  static Future<void> store({required Locale local}) async {
    await local_preferences.loadLibrary();
    await local_preferences.LocalPreferences().setString(
        key: local_preferences.LocalPreferences.localizationKey,
        value: local.toLanguageTag());
  }

  static Future<Locale?> getFromStore() async {
    await Future.wait(
        [local_preferences.loadLibrary(), value_handler.loadLibrary()]);
    String? value = await local_preferences.LocalPreferences()
        .getString(key: local_preferences.LocalPreferences.localizationKey);
    if (value_handler.ValueHandler.isTextNotEmptyOrNull(value)) {
      String tag = value!;
      List<String> parts = tag.split("-");

      String languageCode = parts.first;
      String? scriptCode = parts.length == 3 ? parts[1] : null;
      String? countryCode = parts.length >= 2 ? parts.last : null;

      return Locale.fromSubtags(
        languageCode: languageCode,
        scriptCode: scriptCode,
        countryCode: countryCode,
      );
    }
    return null;
  }

  static void changeLanguage({required Locale locale}) {
    CurrentContext()
        .context
        .read<LocalizationBloc>()
        .add(ChangeLanguage(locale: locale));
  }
}
