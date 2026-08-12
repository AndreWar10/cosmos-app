import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/navigation/presentation/pages/root_page.dart';
import 'package:cosmos_app/core/widgets/app_bottom_navigation.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('RootPage', () {
    testWidgets('should render with bottom navigation bar', (tester) async {
      await tester.pumpApp(const RootPage());

      expect(find.byType(AppBottomNavigation), findsOneWidget);
      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('should show Home tab initially', (tester) async {
      await tester.pumpApp(const RootPage());

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 0);
    });

    testWidgets('should switch to News tab when tapped', (tester) async {
      await tester.pumpApp(const RootPage());

      await tester.tap(find.byIcon(Icons.article_outlined));
      await tester.pumpAndSettle();

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 1);
    });

    testWidgets('should switch to Launches tab when tapped', (tester) async {
      await tester.pumpApp(const RootPage());

      await tester.tap(find.byIcon(Icons.rocket_launch_outlined));
      await tester.pumpAndSettle();

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 2);
    });

    testWidgets('should switch to Settings tab when tapped', (tester) async {
      await tester.pumpApp(const RootPage());

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 3);
    });
  });
}
