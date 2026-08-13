import '../entities/quiz_question.dart';
import '../repositories/quiz_repository.dart';

class GetQuizQuestionsUseCase {
  const GetQuizQuestionsUseCase(this._repository);

  final QuizRepository _repository;

  Future<List<QuizQuestion>> call({String? categoryId}) =>
      _repository.getQuestions(categoryId: categoryId);
}
