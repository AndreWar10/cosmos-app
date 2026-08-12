import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/settings/presentation/pages/settings_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('SettingsPage', () {
    testWidgets('should render appearance and language sections',
        (tester) async {
      await tester.pumpApp(const SettingsPage());

      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.byType(SegmentedButton<String>), findsOneWidget);
    });

    testWidgets('should toggle theme when switch is tapped', (tester) async {
      await tester.pumpApp(const SettingsPage());

      final switchTile = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(switchTile.value, isTrue);

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      final updatedSwitch = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(updatedSwitch.value, isFalse);
    });

    testWidgets('should switch locale when EN segment is tapped',
        (tester) async {
      await tester.pumpApp(const SettingsPage());

      await tester.tap(find.text('EN'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
