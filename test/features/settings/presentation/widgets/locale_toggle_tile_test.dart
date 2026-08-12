import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/settings/presentation/widgets/locale_toggle_tile.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('LocaleToggleTile', () {
    testWidgets('should render language icon', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: LocaleToggleTile(
            isPortuguese: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('should show PT selected when isPortuguese is true',
        (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: LocaleToggleTile(
            isPortuguese: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(SegmentedButton<String>), findsOneWidget);
    });

    testWidgets('should call onChanged with en locale when EN is tapped',
        (tester) async {
      Locale? newLocale;

      await tester.pumpApp(
        Scaffold(
          body: LocaleToggleTile(
            isPortuguese: true,
            onChanged: (locale) => newLocale = locale,
          ),
        ),
      );

      await tester.tap(find.text('EN'));
      await tester.pump();

      expect(newLocale, const Locale('en'));
    });
  });
}
