import 'package:material_ui/material_ui.dart';

import 'package:dbnus/core/localization/app_localizations/app_localizations.dart';
import 'package:dbnus/core/localization/app_localizations/app_localizations_en.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? AppLocalizationsEn();
}
