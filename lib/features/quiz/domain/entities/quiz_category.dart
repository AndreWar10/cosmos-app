class QuizCategory {
  const QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.questionCount,
  });

  final String id;
  final String name;
  final String icon;
  final int questionCount;
}
