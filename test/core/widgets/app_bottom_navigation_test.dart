import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/widgets/app_bottom_navigation.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppBottomNavigation', () {
    testWidgets('should render 4 navigation items', (tester) async {
      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.items.length, 4);
    });

    testWidgets('should highlight the current tab', (tester) async {
      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: 2,
            onTap: (_) {},
          ),
        ),
      );

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 2);
    });

    testWidgets('should call onTap when a tab is tapped', (tester) async {
      int tappedIndex = -1;

      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: 0,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.article_outlined));
      expect(tappedIndex, 1);
    });
  });
}
