import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/launches/domain/entities/launch.dart';
import 'package:cosmos_app/features/launches/presentation/bloc/launches_bloc.dart';
import 'package:cosmos_app/features/launches/presentation/bloc/launches_event.dart';
import 'package:cosmos_app/features/launches/presentation/bloc/launches_state.dart';
import 'package:cosmos_app/features/launches/presentation/widgets/launch_card.dart';
import 'package:cosmos_app/features/launches/presentation/widgets/launches_loading_indicator.dart';
import 'package:cosmos_app/features/launches/presentation/widgets/launches_error_widget.dart';
import 'package:cosmos_app/features/launches/presentation/widgets/launches_empty_widget.dart';

import '../../../../helpers/pump_app.dart';

class MockLaunchesBloc extends MockBloc<LaunchesEvent, LaunchesState>
    implements LaunchesBloc {}

void main() {
  late MockLaunchesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(LaunchesFetched());
    registerFallbackValue(LaunchesInitial());
  });

  setUp(() => mockBloc = MockLaunchesBloc());

  final tLaunches = [
    Launch(
      id: '123',
      name: 'Test Launch',
      flightNumber: 1,
      dateUtc: DateTime.utc(2026, 8, 15),
      success: null,
      upcoming: true,
      details: null,
      rocket: 'Falcon 9',
      launchpad: 'SLC-40',
      links: const LaunchLinks(),
    ),
  ];

  Widget buildPage(LaunchesState state) {
    when(() => mockBloc.state).thenReturn(state);
    return BlocProvider<LaunchesBloc>.value(
      value: mockBloc,
      child: Scaffold(
        body: BlocBuilder<LaunchesBloc, LaunchesState>(
          builder: (context, state) {
            return switch (state) {
              LaunchesInitial() => const SizedBox.shrink(),
              LaunchesLoading() => const LaunchesLoadingIndicator(),
              LaunchesError(:final message) => LaunchesErrorWidget(
                  message: message,
                  onRetry: () {},
                ),
              LaunchesLoaded(:final launches) => launches.isEmpty
                  ? const LaunchesEmptyWidget()
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      padding: const EdgeInsets.all(16),
                      itemCount: launches.length,
                      itemBuilder: (_, i) =>
                          LaunchCard(launch: launches[i]),
                    ),
            };
          },
        ),
      ),
    );
  }

  group('LaunchesPage states', () {
    testWidgets('should show loading indicator when state is LaunchesLoading',
        (tester) async {
      await tester.pumpApp(buildPage(LaunchesLoading()));

      expect(find.byType(LaunchesLoadingIndicator), findsOneWidget);
    });

    testWidgets('should show error widget when state is LaunchesError',
        (tester) async {
      await tester.pumpApp(buildPage(LaunchesError('Failed')));

      expect(find.byType(LaunchesErrorWidget), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets('should show empty widget when loaded with no launches',
        (tester) async {
      await tester.pumpApp(
        buildPage(LaunchesLoaded(
          launches: [],
          count: 0,
          upcomingFilter: true,
        )),
      );

      expect(find.byType(LaunchesEmptyWidget), findsOneWidget);
    });

    testWidgets('should show launch cards when loaded with data',
        (tester) async {
      await tester.pumpApp(
        buildPage(LaunchesLoaded(
          launches: tLaunches,
          count: 1,
          upcomingFilter: true,
        )),
      );

      expect(find.byType(LaunchCard), findsOneWidget);
      expect(find.text('Test Launch'), findsOneWidget);
    });
  });
}
