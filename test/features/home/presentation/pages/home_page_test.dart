import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/home/presentation/pages/home_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('HomePage', () {
    testWidgets('should render with app bar title', (tester) async {
      await tester.pumpApp(const HomePage());

      expect(find.text('Cosmos'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
