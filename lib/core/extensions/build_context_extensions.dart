import 'package:flutter/material.dart';

import '../../i18n/generated/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}
