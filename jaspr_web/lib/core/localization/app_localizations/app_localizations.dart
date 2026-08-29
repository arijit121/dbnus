import '../../enums/language_enum.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

abstract class AppLocalizations {
  final String localeName;
  AppLocalizations(this.localeName);

  static List<Locale> supportedLocales = const [
    Locale('en'),
    Locale('es')
  ];

  String get hello_world;
  String get profile;
  String get edit_profile;
  String get completed_topics;
  String get completed_lessons;
  String get completed_quiz;
  String get completed_games;
  String get change_language;
  String get logout;
  String get logout_confirmation;
  String get serial_number;
  String get title;
  String get completed_at;
  String get name;
  String get email;
  String get phone_number;
  String get submit;
  String get cancel;
  String get ok;
  String cannot_be_blank(String field);
  String length_greater_than(String field, int minLength);
  String enter_valid_msg(String field);
  String get enter_valid_date;
  String get date_cannot_be_blank;
  String get email_validator;
  String get phone_validation;
  String enter_value(String value);
  String get otp;
  String get dashboard;
  String get leader_board;
  String get order;
  String get game;
  String get bioData;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }
  return AppLocalizationsEn();
}
