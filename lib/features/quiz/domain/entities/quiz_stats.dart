class QuizStats {
  const QuizStats({
    required this.highScores,
    required this.totalAnswered,
    required this.totalCorrect,
  });

  final Map<String, int> highScores;
  final int totalAnswered;
  final int totalCorrect;

  double get overallPercentage =>
      totalAnswered > 0 ? totalCorrect / totalAnswered : 0;

  int highScoreFor(String categoryId) => highScores[categoryId] ?? 0;
}
