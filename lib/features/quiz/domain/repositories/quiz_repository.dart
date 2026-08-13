import '../entities/quiz_category.dart';
import '../entities/quiz_question.dart';
import '../entities/quiz_stats.dart';

abstract class QuizRepository {
  Future<List<QuizCategory>> getCategories();
  Future<List<QuizQuestion>> getQuestions({String? categoryId});
  Future<QuizStats> getStats();
  Future<void> saveResult({
    required String categoryId,
    required int score,
    required int totalQuestions,
  });
}
