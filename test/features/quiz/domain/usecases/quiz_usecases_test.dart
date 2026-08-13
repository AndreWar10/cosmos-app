import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/quiz/domain/entities/quiz_category.dart';
import 'package:cosmos_app/features/quiz/domain/entities/quiz_question.dart';
import 'package:cosmos_app/features/quiz/domain/entities/quiz_stats.dart';
import 'package:cosmos_app/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:cosmos_app/features/quiz/domain/usecases/get_quiz_categories_usecase.dart';
import 'package:cosmos_app/features/quiz/domain/usecases/get_quiz_questions_usecase.dart';
import 'package:cosmos_app/features/quiz/domain/usecases/get_quiz_stats_usecase.dart';
import 'package:cosmos_app/features/quiz/domain/usecases/save_quiz_result_usecase.dart';

class MockQuizRepository extends Mock implements QuizRepository {}

void main() {
  late MockQuizRepository mockRepository;

  setUp(() {
    mockRepository = MockQuizRepository();
  });

  group('GetQuizCategoriesUseCase', () {
    test('should delegate to repository', () async {
      final categories = [
        const QuizCategory(
            id: 'solar', name: 'Solar System', icon: '🪐', questionCount: 10),
      ];
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => categories);

      final useCase = GetQuizCategoriesUseCase(mockRepository);
      final result = await useCase();

      expect(result, categories);
      verify(() => mockRepository.getCategories()).called(1);
    });
  });

  group('GetQuizQuestionsUseCase', () {
    test('should delegate to repository with categoryId', () async {
      final questions = [
        const QuizQuestion(
          id: '1',
          category: 'solar',
          question: 'Test?',
          options: ['A', 'B', 'C', 'D'],
          correctIndex: 0,
          explanation: 'Because A',
        ),
      ];
      when(() => mockRepository.getQuestions(categoryId: 'solar'))
          .thenAnswer((_) async => questions);

      final useCase = GetQuizQuestionsUseCase(mockRepository);
      final result = await useCase(categoryId: 'solar');

      expect(result, questions);
      verify(() => mockRepository.getQuestions(categoryId: 'solar')).called(1);
    });

    test('should delegate to repository without categoryId', () async {
      when(() => mockRepository.getQuestions(categoryId: null))
          .thenAnswer((_) async => []);

      final useCase = GetQuizQuestionsUseCase(mockRepository);
      final result = await useCase();

      expect(result, isEmpty);
      verify(() => mockRepository.getQuestions(categoryId: null)).called(1);
    });
  });

  group('GetQuizStatsUseCase', () {
    test('should delegate to repository', () async {
      const stats = QuizStats(
        highScores: {'solar': 5},
        totalAnswered: 10,
        totalCorrect: 5,
      );
      when(() => mockRepository.getStats()).thenAnswer((_) async => stats);

      final useCase = GetQuizStatsUseCase(mockRepository);
      final result = await useCase();

      expect(result, stats);
      verify(() => mockRepository.getStats()).called(1);
    });
  });

  group('SaveQuizResultUseCase', () {
    test('should delegate to repository with correct params', () async {
      when(() => mockRepository.saveResult(
            categoryId: any(named: 'categoryId'),
            score: any(named: 'score'),
            totalQuestions: any(named: 'totalQuestions'),
          )).thenAnswer((_) async {});

      final useCase = SaveQuizResultUseCase(mockRepository);
      await useCase(categoryId: 'solar', score: 7, totalQuestions: 10);

      verify(() => mockRepository.saveResult(
            categoryId: 'solar',
            score: 7,
            totalQuestions: 10,
          )).called(1);
    });
  });
}
