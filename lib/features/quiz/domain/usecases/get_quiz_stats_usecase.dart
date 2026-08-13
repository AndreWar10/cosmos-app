import '../entities/quiz_stats.dart';
import '../repositories/quiz_repository.dart';

class GetQuizStatsUseCase {
  const GetQuizStatsUseCase(this._repository);

  final QuizRepository _repository;

  Future<QuizStats> call() => _repository.getStats();
}
