class QuizResult {
  const QuizResult({
    required this.categoryId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTakenSeconds,
  });

  final String categoryId;
  final int totalQuestions;
  final int correctAnswers;
  final int timeTakenSeconds;

  double get percentage =>
      totalQuestions > 0 ? correctAnswers / totalQuestions : 0;

  int get wrongAnswers => totalQuestions - correctAnswers;
}
