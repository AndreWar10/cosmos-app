import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/launches/domain/entities/launch.dart';
import 'package:cosmos_app/features/launches/presentation/widgets/launch_card.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  final tLaunch = Launch(
    id: '123',
    name: 'Falcon 9 Block 5 | Starlink',
    flightNumber: 715,
    dateUtc: DateTime.utc(2026, 8, 15),
    success: true,
    upcoming: false,
    details: 'Details',
    rocket: 'Falcon 9 Block 5',
    launchpad: 'SLC-40',
    links: const LaunchLinks(),
  );

  final tUpcomingLaunch = Launch(
    id: '456',
    name: 'Crew Dragon',
    flightNumber: 800,
    dateUtc: DateTime.utc(2027, 1, 1),
    success: null,
    upcoming: true,
    details: null,
    rocket: 'Falcon 9',
    launchpad: 'LC-39A',
    links: const LaunchLinks(),
  );

  group('LaunchCard', () {
    testWidgets('should display launch name and rocket', (tester) async {
      await tester.pumpApp(LaunchCard(launch: tLaunch));

      expect(find.text('Falcon 9 Block 5 | Starlink'), findsOneWidget);
      expect(find.text('Falcon 9 Block 5'), findsOneWidget);
    });

    testWidgets('should display formatted date', (tester) async {
      await tester.pumpApp(LaunchCard(launch: tLaunch));

      expect(find.text('15/08/2026'), findsOneWidget);
    });

    testWidgets('should show success badge for past successful launch',
        (tester) async {
      await tester.pumpApp(LaunchCard(launch: tLaunch));

      expect(find.text('Sucesso'), findsOneWidget);
    });

    testWidgets('should show upcoming badge for upcoming launch',
        (tester) async {
      await tester.pumpApp(LaunchCard(launch: tUpcomingLaunch));

      expect(find.text('Próximo'), findsOneWidget);
    });

    testWidgets('should call onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        LaunchCard(launch: tLaunch, onTap: () => tapped = true),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('should show rocket icon when no patch image', (tester) async {
      await tester.pumpApp(LaunchCard(launch: tLaunch));

      expect(find.byIcon(Icons.rocket_launch), findsOneWidget);
    });
  });
}
