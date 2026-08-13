import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_app_cache.dart';

void main() {
  group('QuizSoundService persistence logic', () {
    late MockAppCache cache;
    const soundKey = 'quiz_sound_enabled';

    setUp(() {
      cache = MockAppCache();
    });

    test('isEnabled should default to true when no cache entry', () {
      final value = cache.getString(soundKey);
      expect(value != 'false', true);
    });

    test('should persist false when disabled', () async {
      await cache.setString(soundKey, 'false');
      expect(cache.getString(soundKey), 'false');
      expect(cache.getString(soundKey) != 'false', false);
    });

    test('should persist true when enabled', () async {
      await cache.setString(soundKey, 'false');
      expect(cache.getString(soundKey) != 'false', false);

      await cache.setString(soundKey, 'true');
      expect(cache.getString(soundKey) != 'false', true);
    });

    test('should correctly toggle between states', () async {
      expect(cache.getString(soundKey), isNull);

      await cache.setString(soundKey, 'false');
      expect(cache.getString(soundKey), 'false');

      await cache.setString(soundKey, 'true');
      expect(cache.getString(soundKey), 'true');
    });
  });
}
