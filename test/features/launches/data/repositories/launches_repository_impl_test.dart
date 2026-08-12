import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/launches/data/datasources/launches_remote_datasource.dart';
import 'package:cosmos_app/features/launches/data/models/launch_model.dart';
import 'package:cosmos_app/features/launches/data/repositories/launches_repository_impl.dart';

class MockLaunchesRemoteDataSource extends Mock
    implements LaunchesRemoteDataSource {}

void main() {
  late MockLaunchesRemoteDataSource mockDataSource;
  late LaunchesRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockLaunchesRemoteDataSource();
    repository = LaunchesRepositoryImpl(mockDataSource);
  });

  final tLaunches = [
    LaunchModel(
      id: '123',
      name: 'Test Launch',
      flightNumber: 1,
      dateUtc: DateTime.utc(2026, 8, 15),
      success: null,
      upcoming: true,
      details: null,
      rocket: 'Falcon 9',
      launchpad: 'SLC-40',
      links: const LaunchLinksModel(),
    ),
  ];

  final tDataResult = (launches: tLaunches, count: 50);

  group('getLaunches', () {
    test('should delegate to datasource with correct params', () async {
      when(() => mockDataSource.getLaunches(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            upcoming: any(named: 'upcoming'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => tDataResult);

      await repository.getLaunches(
        limit: 10,
        offset: 20,
        upcoming: true,
        status: 'success',
      );

      verify(() => mockDataSource.getLaunches(
            limit: 10,
            offset: 20,
            upcoming: true,
            status: 'success',
          )).called(1);
    });

    test('should return launches and count', () async {
      when(() => mockDataSource.getLaunches(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            upcoming: any(named: 'upcoming'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => tDataResult);

      final result = await repository.getLaunches();

      expect(result.launches.length, 1);
      expect(result.count, 50);
      expect(result.launches.first.name, 'Test Launch');
    });

    test('should throw when datasource fails', () async {
      when(() => mockDataSource.getLaunches(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            upcoming: any(named: 'upcoming'),
            status: any(named: 'status'),
          )).thenThrow(Exception('Network error'));

      expect(() => repository.getLaunches(), throwsA(isA<Exception>()));
    });
  });

  group('getNextLaunch', () {
    test('should delegate to datasource', () async {
      when(() => mockDataSource.getNextLaunch())
          .thenAnswer((_) async => tLaunches.first);

      final result = await repository.getNextLaunch();

      expect(result.name, 'Test Launch');
      verify(() => mockDataSource.getNextLaunch()).called(1);
    });
  });

  group('getLatestLaunch', () {
    test('should delegate to datasource', () async {
      when(() => mockDataSource.getLatestLaunch())
          .thenAnswer((_) async => tLaunches.first);

      final result = await repository.getLatestLaunch();

      expect(result.name, 'Test Launch');
      verify(() => mockDataSource.getLatestLaunch()).called(1);
    });
  });
}
