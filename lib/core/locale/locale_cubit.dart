import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_provider.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._localeProvider) : super(const Locale('pt'));

  final LocaleProvider _localeProvider;

  void setLocale(Locale locale) {
    _localeProvider.setLanguageCode(locale.languageCode);
    emit(locale);
  }

  bool get isPortuguese => state.languageCode == 'pt';
}
