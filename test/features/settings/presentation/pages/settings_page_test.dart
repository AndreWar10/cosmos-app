import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/core/cache/app_cache.dart';
import 'package:cosmos_app/features/settings/presentation/pages/settings_page.dart';
import 'package:cosmos_app/features/quiz/data/services/quiz_sound_service.dart';

import '../../../../helpers/pump_app.dart';

class MockAppCache extends Mock implements AppCache {}

void main() {
  setUp(() {
    final mockCache = MockAppCache();
    when(() => mockCache.getString(any())).thenReturn(null);

    final sl = GetIt.instance;
    if (sl.isRegistered<QuizSoundService>()) sl.unregister<QuizSoundService>();
    sl.registerLazySingleton<QuizSoundService>(
      () => QuizSoundService(mockCache),
    );
  });

  tearDown(() {
    final sl = GetIt.instance;
    if (sl.isRegistered<QuizSoundService>()) sl.unregister<QuizSoundService>();
  });

  group('SettingsPage', () {
    testWidgets('should render appearance and language sections',
        (tester) async {
      await tester.pumpApp(const SettingsPage());

      expect(find.byType(Switch), findsNWidgets(2));
      expect(find.byType(SegmentedButton<String>), findsOneWidget);
    });

    testWidgets('should toggle theme when switch is tapped', (tester) async {
      await tester.pumpApp(const SettingsPage());

      final switches = find.byType(Switch);
      final themeSwitch = tester.widget<Switch>(switches.first);
      expect(themeSwitch.value, isTrue);

      await tester.tap(switches.first);
      await tester.pump();

      final updatedSwitch = tester.widget<Switch>(switches.first);
      expect(updatedSwitch.value, isFalse);
    });

    testWidgets('should switch locale when EN segment is tapped',
        (tester) async {
      await tester.pumpApp(const SettingsPage());

      final enFinder = find.text('EN');
      expect(enFinder, findsOneWidget);

      await tester.tap(enFinder);
      await tester.pump();

      final ptFinder = find.text('PT');
      expect(ptFinder, findsOneWidget);
    });
  });
}
