import '../../domain/entities/quiz_category.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/quiz_stats.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  const QuizRepositoryImpl(this._dataSource);

  final QuizLocalDataSource _dataSource;

  @override
  Future<List<QuizCategory>> getCategories() => _dataSource.getCategories();

  @override
  Future<List<QuizQuestion>> getQuestions({String? categoryId}) =>
      _dataSource.getQuestions(categoryId: categoryId);

  @override
  Future<QuizStats> getStats() => _dataSource.getStats();

  @override
  Future<void> saveResult({
    required String categoryId,
    required int score,
    required int totalQuestions,
  }) =>
      _dataSource.saveResult(
        categoryId: categoryId,
        score: score,
        totalQuestions: totalQuestions,
      );
}
