import 'package:jaspr/jaspr.dart';
import '../../enums/language_enum.dart';
import '../../storage/local_preferences.dart';
import '../provider/localization_provider.dart';

class LocalizationUtils {
  static List<Locale> supportedLocales =
      LanguageEnum.values.map((language) => language.locale).toList();

  static const String localizationKey = "LocalizationKey";

  static Future<void> store({required Locale locale}) async {
    await LocalPreferences().setString(
      key: localizationKey,
      value: locale.toLanguageTag(),
    );
  }

  static Future<Locale?> getFromStore() async {
    final value = await LocalPreferences().getString(key: localizationKey);
    if (value != null && value.isNotEmpty) {
      final parts = value.split("-");
      final languageCode = parts.first;
      final countryCode = parts.length >= 2 ? parts.last : null;
      return Locale(languageCode, countryCode);
    }
    return null;
  }

  static void changeLanguage({required BuildContext context, required Locale locale}) {
    final provider = LocalizationProvider.of(context);
    if (provider != null) {
      provider.onChangeLocale(locale);
    }
  }
}
