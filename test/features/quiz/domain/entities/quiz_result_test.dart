import 'package:flutter_test/flutter_test.dart';
import 'package:cosmos_app/features/quiz/domain/entities/quiz_result.dart';

void main() {
  group('QuizResult', () {
    test('percentage should be 0 when totalQuestions is 0', () {
      const result = QuizResult(
        categoryId: 'test',
        totalQuestions: 0,
        correctAnswers: 0,
        timeTakenSeconds: 10,
      );
      expect(result.percentage, 0);
    });

    test('percentage should calculate correctly', () {
      const result = QuizResult(
        categoryId: 'test',
        totalQuestions: 10,
        correctAnswers: 7,
        timeTakenSeconds: 60,
      );
      expect(result.percentage, 0.7);
    });

    test('percentage should be 1.0 for perfect score', () {
      const result = QuizResult(
        categoryId: 'test',
        totalQuestions: 5,
        correctAnswers: 5,
        timeTakenSeconds: 30,
      );
      expect(result.percentage, 1.0);
    });

    test('wrongAnswers should be total minus correct', () {
      const result = QuizResult(
        categoryId: 'test',
        totalQuestions: 10,
        correctAnswers: 3,
        timeTakenSeconds: 45,
      );
      expect(result.wrongAnswers, 7);
    });

    test('wrongAnswers should be 0 for perfect score', () {
      const result = QuizResult(
        categoryId: 'test',
        totalQuestions: 5,
        correctAnswers: 5,
        timeTakenSeconds: 20,
      );
      expect(result.wrongAnswers, 0);
    });
  });
}
