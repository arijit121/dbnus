import 'package:dbnus/service/context_service.dart';
import 'package:dbnus/service/value_handler.dart';
import 'package:dbnus/storage/local_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../enum/language_enum.dart';
import '../bloc/localization_bloc.dart';

class LocalizationUtils {
  static List<Locale> supportedLocales =
      LanguageEnum.values.map((language) => language.locale).toList();

  Future<void> store({required Locale local}) async {
    await LocalPreferences().setString(
        key: LocalPreferences.localizationKey, value: local.toLanguageTag());
  }

  Future<Locale?> getFromStore() async {
    String? value = await LocalPreferences()
        .getString(key: LocalPreferences.localizationKey);
    if (ValueHandler().isTextNotEmptyOrNull(value)) {
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

  void changeLanguage({required Locale locale}) {
    CurrentContext()
        .context
        .read<LocalizationBloc>()
        .add(ChangeLanguage(locale: locale));
  }
}
