import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/launches/presentation/pages/launches_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('LaunchesPage', () {
    testWidgets('should render with app bar title', (tester) async {
      await tester.pumpApp(const LaunchesPage());

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
