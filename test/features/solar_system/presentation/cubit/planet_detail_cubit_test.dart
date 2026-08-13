import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/home/domain/entities/planet_info.dart';
import 'package:cosmos_app/features/home/domain/repositories/planet_repository.dart';
import 'package:cosmos_app/features/home/domain/usecases/get_planet_info_usecase.dart';
import 'package:cosmos_app/features/solar_system/presentation/cubit/planet_detail_cubit.dart';

class MockPlanetRepository extends Mock implements PlanetRepository {}

void main() {
  late MockPlanetRepository mockRepository;
  late GetPlanetInfoUseCase getPlanetInfoUseCase;

  const testPlanetInfo = PlanetInfo(
    id: 'earth',
    name: 'Earth',
    type: 'Terrestrial',
    resume: 'Our home planet',
    features: PlanetFeatures(
      orbitalPeriod: ['365.25 days'],
      orbitalSpeed: '29.78 km/s',
      rotationDuration: '23h 56m',
      radius: '6,371 km',
      diameter: '12,742 km',
      sunDistance: '149.6 million km',
      temperature: '15°C average',
      gravity: '9.8 m/s²',
      oneWayLightToTheSun: '8 min 19 sec',
    ),
    satellites: PlanetSatellites(
      number: 1,
      names: ['Moon'],
    ),
  );

  setUp(() {
    mockRepository = MockPlanetRepository();
    getPlanetInfoUseCase = GetPlanetInfoUseCase(mockRepository);
  });

  group('GetPlanetInfoUseCase', () {
    test('should delegate to repository', () {
      when(() => mockRepository.getPlanetInfo('earth'))
          .thenReturn(testPlanetInfo);

      final result = getPlanetInfoUseCase('earth');

      expect(result, testPlanetInfo);
      expect(result!.name, 'Earth');
      verify(() => mockRepository.getPlanetInfo('earth')).called(1);
    });

    test('should return null for unknown planet', () {
      when(() => mockRepository.getPlanetInfo('unknown')).thenReturn(null);

      final result = getPlanetInfoUseCase('unknown');

      expect(result, isNull);
    });
  });

  group('PlanetDetailCubit', () {
    test('initial state should be PlanetDetailInitial', () {
      final cubit = PlanetDetailCubit(getPlanetInfoUseCase);
      expect(cubit.state, isA<PlanetDetailInitial>());
      cubit.close();
    });

    blocTest<PlanetDetailCubit, PlanetDetailState>(
      'load should emit PlanetDetailLoaded when planet found',
      setUp: () {
        when(() => mockRepository.getPlanetInfo('earth'))
            .thenReturn(testPlanetInfo);
      },
      build: () => PlanetDetailCubit(getPlanetInfoUseCase),
      act: (cubit) => cubit.load('earth'),
      expect: () => [isA<PlanetDetailLoaded>()],
      verify: (cubit) {
        final state = cubit.state as PlanetDetailLoaded;
        expect(state.info.name, 'Earth');
        expect(state.info.satellites.number, 1);
        expect(state.info.features.gravity, '9.8 m/s²');
      },
    );

    blocTest<PlanetDetailCubit, PlanetDetailState>(
      'load should emit PlanetDetailError when planet not found',
      setUp: () {
        when(() => mockRepository.getPlanetInfo('unknown')).thenReturn(null);
      },
      build: () => PlanetDetailCubit(getPlanetInfoUseCase),
      act: (cubit) => cubit.load('unknown'),
      expect: () => [isA<PlanetDetailError>()],
    );
  });
}
