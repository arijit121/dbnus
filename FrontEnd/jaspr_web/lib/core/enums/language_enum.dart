import '../../shared/extensions/logger_extension.dart';

class Locale {
  final String languageCode;
  final String? countryCode;
  final String? scriptCode;

  const Locale(this.languageCode, [this.countryCode]) : scriptCode = null;

  const Locale.fromSubtags({
    required this.languageCode,
    this.countryCode,
    this.scriptCode,
  });

  String toLanguageTag() {
    final buf = StringBuffer(languageCode);
    if (scriptCode != null) buf.write('-$scriptCode');
    if (countryCode != null) buf.write('-$countryCode');
    return buf.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is Locale &&
      other.languageCode == languageCode &&
      other.countryCode == countryCode &&
      other.scriptCode == scriptCode;

  @override
  int get hashCode => Object.hash(languageCode, countryCode, scriptCode);

  @override
  String toString() => toLanguageTag();
}

enum LanguageEnum {
  english('1', "English", Locale("en")),
  spanish('2', "Spanish", Locale("es"));

  final String value, name;
  final Locale locale;

  const LanguageEnum(this.value, this.name, this.locale);

  static LanguageEnum? getLanguageFromLocale({required Locale? locale}) {
    try {
      if (locale == null) return null;
      return LanguageEnum.values.firstWhere((language) =>
          language.locale.toLanguageTag() == locale.toLanguageTag());
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }
}
