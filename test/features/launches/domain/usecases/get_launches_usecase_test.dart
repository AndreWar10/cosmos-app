import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/launches/domain/entities/launch.dart';
import 'package:cosmos_app/features/launches/domain/repositories/launches_repository.dart';
import 'package:cosmos_app/features/launches/domain/usecases/get_launches_usecase.dart';

class MockLaunchesRepository extends Mock implements LaunchesRepository {}

void main() {
  late MockLaunchesRepository mockRepository;
  late GetLaunchesUseCase useCase;

  setUp(() {
    mockRepository = MockLaunchesRepository();
    useCase = GetLaunchesUseCase(mockRepository);
  });

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

  final tResult = (launches: tLaunches, count: 50);

  group('GetLaunchesUseCase', () {
    test('should delegate to repository with correct params', () async {
      when(() => mockRepository.getLaunches(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            upcoming: any(named: 'upcoming'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => tResult);

      final result = await useCase(
        limit: 10,
        offset: 20,
        upcoming: true,
        status: 'success',
      );

      expect(result.launches, tLaunches);
      expect(result.count, 50);
      verify(() => mockRepository.getLaunches(
            limit: 10,
            offset: 20,
            upcoming: true,
            status: 'success',
          )).called(1);
    });

    test('should use default params when not provided', () async {
      when(() => mockRepository.getLaunches(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            upcoming: any(named: 'upcoming'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => tResult);

      await useCase();

      verify(() => mockRepository.getLaunches(
            limit: 20,
            offset: 0,
            upcoming: null,
            status: null,
          )).called(1);
    });
  });
}
