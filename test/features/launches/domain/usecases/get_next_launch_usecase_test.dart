import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/launches/domain/entities/launch.dart';
import 'package:cosmos_app/features/launches/domain/repositories/launches_repository.dart';
import 'package:cosmos_app/features/launches/domain/usecases/get_next_launch_usecase.dart';

class MockLaunchesRepository extends Mock implements LaunchesRepository {}

void main() {
  late MockLaunchesRepository mockRepository;
  late GetNextLaunchUseCase useCase;

  setUp(() {
    mockRepository = MockLaunchesRepository();
    useCase = GetNextLaunchUseCase(mockRepository);
  });

  final tLaunch = Launch(
    id: '123',
    name: 'Next Launch',
    flightNumber: 100,
    dateUtc: DateTime.utc(2026, 8, 20),
    success: null,
    upcoming: true,
    details: null,
    rocket: 'Falcon Heavy',
    launchpad: 'LC-39A',
    links: const LaunchLinks(),
  );

  group('GetNextLaunchUseCase', () {
    test('should delegate to repository.getNextLaunch()', () async {
      when(() => mockRepository.getNextLaunch())
          .thenAnswer((_) async => tLaunch);

      final result = await useCase();

      expect(result, tLaunch);
      expect(result.name, 'Next Launch');
      verify(() => mockRepository.getNextLaunch()).called(1);
    });

    test('should throw when repository fails', () async {
      when(() => mockRepository.getNextLaunch())
          .thenThrow(Exception('Network error'));

      expect(() => useCase(), throwsA(isA<Exception>()));
    });
  });
}
