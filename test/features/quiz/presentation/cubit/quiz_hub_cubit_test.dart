import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/quiz/domain/entities/quiz_category.dart';
import 'package:cosmos_app/features/quiz/domain/entities/quiz_stats.dart';
import 'package:cosmos_app/features/quiz/domain/usecases/get_quiz_categories_usecase.dart';
import 'package:cosmos_app/features/quiz/domain/usecases/get_quiz_stats_usecase.dart';
import 'package:cosmos_app/features/quiz/presentation/cubit/quiz_hub_cubit.dart';

class MockGetQuizCategoriesUseCase extends Mock
    implements GetQuizCategoriesUseCase {}

class MockGetQuizStatsUseCase extends Mock implements GetQuizStatsUseCase {}

void main() {
  late MockGetQuizCategoriesUseCase mockGetCategories;
  late MockGetQuizStatsUseCase mockGetStats;

  final categories = [
    const QuizCategory(
        id: 'solar', name: 'Solar System', icon: '🪐', questionCount: 13),
    const QuizCategory(
        id: 'exploration',
        name: 'Space Exploration',
        icon: '🚀',
        questionCount: 12),
  ];

  const stats = QuizStats(
    highScores: {'solar': 10},
    totalAnswered: 50,
    totalCorrect: 35,
  );

  setUp(() {
    mockGetCategories = MockGetQuizCategoriesUseCase();
    mockGetStats = MockGetQuizStatsUseCase();
  });

  group('QuizHubCubit', () {
    test('initial state should be QuizHubInitial', () {
      final cubit = QuizHubCubit(mockGetCategories, mockGetStats);
      expect(cubit.state, isA<QuizHubInitial>());
      cubit.close();
    });

    blocTest<QuizHubCubit, QuizHubState>(
      'should emit [Loading, Loaded] when load succeeds',
      build: () {
        when(() => mockGetCategories()).thenAnswer((_) async => categories);
        when(() => mockGetStats()).thenAnswer((_) async => stats);
        return QuizHubCubit(mockGetCategories, mockGetStats);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<QuizHubLoading>(),
        isA<QuizHubLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGetCategories()).called(1);
        verify(() => mockGetStats()).called(1);
      },
    );

    blocTest<QuizHubCubit, QuizHubState>(
      'loaded state should contain categories and stats',
      build: () {
        when(() => mockGetCategories()).thenAnswer((_) async => categories);
        when(() => mockGetStats()).thenAnswer((_) async => stats);
        return QuizHubCubit(mockGetCategories, mockGetStats);
      },
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        final state = cubit.state as QuizHubLoaded;
        expect(state.categories.length, 2);
        expect(state.stats.totalAnswered, 50);
        expect(state.stats.totalCorrect, 35);
      },
    );

    blocTest<QuizHubCubit, QuizHubState>(
      'should emit [Loading, Error] when load fails',
      build: () {
        when(() => mockGetCategories()).thenThrow(Exception('fail'));
        return QuizHubCubit(mockGetCategories, mockGetStats);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<QuizHubLoading>(),
        isA<QuizHubError>(),
      ],
    );
  });
}
