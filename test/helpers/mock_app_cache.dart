import 'package:cosmos_app/core/cache/app_cache.dart';

class MockAppCache implements AppCache {
  final _store = <String, String>{};

  @override
  String? getString(String key) => _store[key];

  @override
  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }
}
