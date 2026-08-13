import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:cosmos_app/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:cosmos_app/features/quiz/domain/entities/quiz_category.dart';
import 'package:cosmos_app/features/quiz/domain/entities/quiz_question.dart';
import 'package:cosmos_app/features/quiz/domain/entities/quiz_stats.dart';

class MockQuizLocalDataSource extends Mock implements QuizLocalDataSource {}

void main() {
  late MockQuizLocalDataSource mockDataSource;
  late QuizRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockQuizLocalDataSource();
    repository = QuizRepositoryImpl(mockDataSource);
  });

  group('QuizRepositoryImpl', () {
    test('getCategories should delegate to datasource', () async {
      final categories = [
        const QuizCategory(
            id: 'solar', name: 'Solar System', icon: '🪐', questionCount: 10),
      ];
      when(() => mockDataSource.getCategories())
          .thenAnswer((_) async => categories);

      final result = await repository.getCategories();

      expect(result, categories);
      verify(() => mockDataSource.getCategories()).called(1);
    });

    test('getQuestions should delegate with categoryId', () async {
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
      when(() => mockDataSource.getQuestions(categoryId: 'solar'))
          .thenAnswer((_) async => questions);

      final result = await repository.getQuestions(categoryId: 'solar');

      expect(result, questions);
    });

    test('getStats should delegate to datasource', () async {
      const stats = QuizStats(
        highScores: {},
        totalAnswered: 0,
        totalCorrect: 0,
      );
      when(() => mockDataSource.getStats()).thenAnswer((_) async => stats);

      final result = await repository.getStats();

      expect(result.totalAnswered, 0);
    });

    test('saveResult should delegate to datasource', () async {
      when(() => mockDataSource.saveResult(
            categoryId: any(named: 'categoryId'),
            score: any(named: 'score'),
            totalQuestions: any(named: 'totalQuestions'),
          )).thenAnswer((_) async {});

      await repository.saveResult(
        categoryId: 'solar',
        score: 7,
        totalQuestions: 10,
      );

      verify(() => mockDataSource.saveResult(
            categoryId: 'solar',
            score: 7,
            totalQuestions: 10,
          )).called(1);
    });
  });
}
