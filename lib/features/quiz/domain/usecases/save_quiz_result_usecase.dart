import '../repositories/quiz_repository.dart';

class SaveQuizResultUseCase {
  const SaveQuizResultUseCase(this._repository);

  final QuizRepository _repository;

  Future<void> call({
    required String categoryId,
    required int score,
    required int totalQuestions,
  }) =>
      _repository.saveResult(
        categoryId: categoryId,
        score: score,
        totalQuestions: totalQuestions,
      );
}
