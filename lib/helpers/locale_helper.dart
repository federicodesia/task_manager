import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:task_manager/helpers/string_helper.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocaleExtension on Locale? {
  String get name{
    final nativeLocaleNames = LocaleNamesLocalizationsDelegate.nativeLocaleNames;
    return (nativeLocaleNames[this?.languageCode] ?? "Unknown").capitalize;
  }
}