import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cache/app_cache.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._cache) : super(ThemeMode.dark) {
    _loadFromCache();
  }

  final AppCache _cache;

  static const _key = 'app_theme_mode';

  void _loadFromCache() {
    final saved = _cache.getString(_key);
    if (saved != null) {
      emit(saved == 'light' ? ThemeMode.light : ThemeMode.dark);
    }
  }

  void toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _cache.setString(_key, next == ThemeMode.dark ? 'dark' : 'light');
    emit(next);
  }

  bool get isDark => state == ThemeMode.dark;
}
