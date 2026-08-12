import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/settings/presentation/widgets/theme_toggle_tile.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('ThemeToggleTile', () {
    testWidgets('should show dark mode icon when isDark is true',
        (tester) async {
      await tester.pumpApp(
        ThemeToggleTile(isDark: true, onChanged: (_) {}),
      );

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('should show light mode icon when isDark is false',
        (tester) async {
      await tester.pumpApp(
        ThemeToggleTile(isDark: false, onChanged: (_) {}),
      );

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('should call onChanged when tapped', (tester) async {
      bool changed = false;

      await tester.pumpApp(
        ThemeToggleTile(
          isDark: true,
          onChanged: (_) => changed = true,
        ),
      );

      await tester.tap(find.byType(SwitchListTile));
      expect(changed, isTrue);
    });
  });
}
