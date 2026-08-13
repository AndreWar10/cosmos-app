import 'package:flutter_test/flutter_test.dart';
import 'package:cosmos_app/features/quiz/domain/entities/quiz_stats.dart';

void main() {
  group('QuizStats', () {
    test('overallPercentage should be 0 when no questions answered', () {
      const stats = QuizStats(
        highScores: {},
        totalAnswered: 0,
        totalCorrect: 0,
      );
      expect(stats.overallPercentage, 0);
    });

    test('overallPercentage should calculate correctly', () {
      const stats = QuizStats(
        highScores: {},
        totalAnswered: 100,
        totalCorrect: 75,
      );
      expect(stats.overallPercentage, 0.75);
    });

    test('highScoreFor should return 0 for unknown category', () {
      const stats = QuizStats(
        highScores: {'solar': 5},
        totalAnswered: 10,
        totalCorrect: 5,
      );
      expect(stats.highScoreFor('unknown'), 0);
    });

    test('highScoreFor should return stored score', () {
      const stats = QuizStats(
        highScores: {'solar': 8, 'exploration': 5},
        totalAnswered: 20,
        totalCorrect: 13,
      );
      expect(stats.highScoreFor('solar'), 8);
      expect(stats.highScoreFor('exploration'), 5);
    });
  });
}
