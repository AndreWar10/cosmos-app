import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/settings/presentation/widgets/settings_section.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('SettingsSection', () {
    testWidgets('should render title and children', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SingleChildScrollView(
            child: SettingsSection(
              title: 'Test Section',
              children: [
                ListTile(title: Text('Item 1')),
                ListTile(title: Text('Item 2')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });
  });
}
