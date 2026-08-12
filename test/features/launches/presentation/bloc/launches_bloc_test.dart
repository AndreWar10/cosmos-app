import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/launches/domain/entities/launch.dart';
import 'package:cosmos_app/features/launches/domain/usecases/get_launches_usecase.dart';
import 'package:cosmos_app/features/launches/presentation/bloc/launches_bloc.dart';
import 'package:cosmos_app/features/launches/presentation/bloc/launches_event.dart';
import 'package:cosmos_app/features/launches/presentation/bloc/launches_state.dart';

class MockGetLaunchesUseCase extends Mock implements GetLaunchesUseCase {}

void main() {
  late MockGetLaunchesUseCase mockUseCase;

  setUp(() => mockUseCase = MockGetLaunchesUseCase());

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

  group('LaunchesBloc', () {
    test('initial state should be LaunchesInitial', () {
      final bloc = LaunchesBloc(mockUseCase);
      expect(bloc.state, isA<LaunchesInitial>());
      bloc.close();
    });

    blocTest<LaunchesBloc, LaunchesState>(
      'should emit [Loading, Loaded] when LaunchesFetched succeeds',
      build: () {
        when(() => mockUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              upcoming: any(named: 'upcoming'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => (launches: tLaunches, count: 1));
        return LaunchesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(LaunchesFetched()),
      expect: () => [
        isA<LaunchesLoading>(),
        isA<LaunchesLoaded>()
            .having((s) => s.launches.length, 'launches length', 1)
            .having((s) => s.count, 'count', 1)
            .having((s) => s.upcomingFilter, 'upcomingFilter', true)
            .having((s) => s.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<LaunchesBloc, LaunchesState>(
      'should emit [Loading, Error] when LaunchesFetched fails',
      build: () {
        when(() => mockUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              upcoming: any(named: 'upcoming'),
              status: any(named: 'status'),
            )).thenThrow(Exception('error'));
        return LaunchesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(LaunchesFetched()),
      expect: () => [
        isA<LaunchesLoading>(),
        isA<LaunchesError>(),
      ],
    );

    blocTest<LaunchesBloc, LaunchesState>(
      'should refetch with new filters on LaunchesFilterChanged',
      build: () {
        when(() => mockUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              upcoming: any(named: 'upcoming'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => (launches: tLaunches, count: 1));
        return LaunchesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(
        LaunchesFilterChanged(upcoming: false, status: 'success'),
      ),
      expect: () => [
        isA<LaunchesLoading>(),
        isA<LaunchesLoaded>()
            .having((s) => s.upcomingFilter, 'upcomingFilter', false)
            .having((s) => s.statusFilter, 'statusFilter', 'success'),
      ],
    );

    blocTest<LaunchesBloc, LaunchesState>(
      'should append launches on LaunchesNextPageFetched',
      build: () {
        when(() => mockUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              upcoming: any(named: 'upcoming'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => (launches: tLaunches, count: 50));
        return LaunchesBloc(mockUseCase);
      },
      seed: () => LaunchesLoaded(
        launches: tLaunches,
        count: 50,
        upcomingFilter: true,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(LaunchesNextPageFetched()),
      expect: () => [
        isA<LaunchesLoaded>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<LaunchesLoaded>()
            .having((s) => s.launches.length, 'launches length', 2),
      ],
    );

    blocTest<LaunchesBloc, LaunchesState>(
      'should not fetch when hasReachedMax is true',
      build: () => LaunchesBloc(mockUseCase),
      seed: () => LaunchesLoaded(
        launches: tLaunches,
        count: 1,
        upcomingFilter: true,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(LaunchesNextPageFetched()),
      expect: () => [],
    );
  });
}
