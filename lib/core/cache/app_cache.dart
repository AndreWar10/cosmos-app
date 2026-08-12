import 'package:shared_preferences/shared_preferences.dart';

abstract class AppCache {
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> remove(String key);
}

class AppCacheImpl implements AppCache {
  AppCacheImpl(this._prefs);

  final SharedPreferences _prefs;

  static const themeKey = 'app_theme_mode';
  static const localeKey = 'app_locale';

  @override
  Future<void> setString(String key, String value) => _prefs.setString(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}
