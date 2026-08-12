import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/news/presentation/pages/news_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('NewsPage', () {
    testWidgets('should render with app bar title', (tester) async {
      await tester.pumpApp(const NewsPage());

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
