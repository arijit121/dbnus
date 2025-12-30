import 'package:flutter/material.dart';

import '../app_localizations/app_localizations.dart';
import '../app_localizations/app_localizations_en.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)?? AppLocalizationsEn();
}
