import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/apod/presentation/cubit/apod_detail_cubit.dart';
import 'package:cosmos_app/features/home/domain/entities/apod.dart';
import 'package:cosmos_app/features/home/domain/usecases/get_apod_usecase.dart';

class MockGetApodUseCase extends Mock implements GetApodUseCase {}

void main() {
  late MockGetApodUseCase mockGetApod;

  const testApod = Apod(
    date: '2024-06-15',
    title: 'Test APOD',
    explanation: 'A test explanation',
    url: 'https://example.com/image.jpg',
    mediaType: 'image',
  );

  const prevDayApod = Apod(
    date: '2024-06-14',
    title: 'Previous Day APOD',
    explanation: 'Previous explanation',
    url: 'https://example.com/prev.jpg',
    mediaType: 'image',
  );

  setUp(() {
    mockGetApod = MockGetApodUseCase();
  });

  group('ApodDetailCubit', () {
    test('init should set apod and parse date', () {
      final cubit = ApodDetailCubit(mockGetApod);
      cubit.init(testApod);

      expect(cubit.state.apod.title, 'Test APOD');
      expect(cubit.state.currentDate, DateTime(2024, 6, 15));
      expect(cubit.state.isLoading, false);
      expect(cubit.state.error, isNull);

      cubit.close();
    });

    test('canGoForward should be true for past dates', () {
      final cubit = ApodDetailCubit(mockGetApod);
      cubit.init(testApod);

      expect(cubit.state.canGoForward, true);

      cubit.close();
    });

    blocTest<ApodDetailCubit, ApodDetailState>(
      'goToPreviousDay should load APOD for previous day',
      setUp: () {
        when(() => mockGetApod(date: '2024-06-14'))
            .thenAnswer((_) async => prevDayApod);
      },
      build: () => ApodDetailCubit(mockGetApod),
      seed: () => ApodDetailState(
        apod: testApod,
        currentDate: DateTime(2024, 6, 15),
      ),
      act: (cubit) => cubit.goToPreviousDay(),
      expect: () => [
        isA<ApodDetailState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.currentDate, 'date', DateTime(2024, 6, 14)),
        isA<ApodDetailState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.apod.title, 'title', 'Previous Day APOD'),
      ],
    );

    blocTest<ApodDetailCubit, ApodDetailState>(
      'goToPreviousDay should emit error on failure',
      setUp: () {
        when(() => mockGetApod(date: any(named: 'date')))
            .thenThrow(Exception('Network error'));
      },
      build: () => ApodDetailCubit(mockGetApod),
      seed: () => ApodDetailState(
        apod: testApod,
        currentDate: DateTime(2024, 6, 15),
      ),
      act: (cubit) => cubit.goToPreviousDay(),
      expect: () => [
        isA<ApodDetailState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ApodDetailState>()
            .having((s) => s.error, 'error', isNotNull),
      ],
    );

    blocTest<ApodDetailCubit, ApodDetailState>(
      'goToNextDay should not emit when already at today',
      build: () => ApodDetailCubit(mockGetApod),
      seed: () {
        final today = DateTime.now();
        return ApodDetailState(
          apod: testApod,
          currentDate: DateTime(today.year, today.month, today.day),
        );
      },
      act: (cubit) => cubit.goToNextDay(),
      expect: () => [],
    );
  });
}
