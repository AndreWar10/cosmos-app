import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/news/presentation/widgets/news_error_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('NewsErrorWidget', () {
    testWidgets('should render error message and retry button', (tester) async {
      await tester.pumpApp(
        NewsErrorWidget(
          message: 'Something went wrong',
          onRetry: () {},
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should call onRetry when button is tapped', (tester) async {
      bool retried = false;

      await tester.pumpApp(
        NewsErrorWidget(
          message: 'Error',
          onRetry: () => retried = true,
        ),
      );

      await tester.tap(find.byType(FilledButton));
      expect(retried, isTrue);
    });
  });
}
