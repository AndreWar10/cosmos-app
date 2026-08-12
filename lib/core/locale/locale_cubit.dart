import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cache/app_cache.dart';
import 'locale_provider.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._localeProvider, this._cache)
      : super(_resolveInitialLocale(_cache)) {
    _localeProvider.setLanguageCode(state.languageCode);
  }

  final LocaleProvider _localeProvider;
  final AppCache _cache;

  static const _key = 'app_locale';
  static const _supportedCodes = {'pt', 'en'};

  static Locale _resolveInitialLocale(AppCache cache) {
    final saved = cache.getString(_key);
    if (saved != null && _supportedCodes.contains(saved)) {
      return Locale(saved);
    }
    final system = PlatformDispatcher.instance.locale.languageCode;
    return Locale(_supportedCodes.contains(system) ? system : 'en');
  }

  void setLocale(Locale locale) {
    _localeProvider.setLanguageCode(locale.languageCode);
    _cache.setString(_key, locale.languageCode);
    emit(locale);
  }

  bool get isPortuguese => state.languageCode == 'pt';
}
