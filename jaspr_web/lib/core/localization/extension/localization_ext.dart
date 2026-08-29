import 'package:jaspr/jaspr.dart';
import '../../enums/language_enum.dart';
import '../app_localizations/app_localizations.dart';
import '../provider/localization_provider.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n {
    final provider = LocalizationProvider.of(this);
    final locale = provider?.locale ?? const Locale('en');
    return lookupAppLocalizations(locale);
  }
}
