import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/quiz_category.dart';

const categoryEmojis = <String, String>{
  'solar_system': '🪐',
  'exploration': '🚀',
  'stars_galaxies': '✨',
  'curiosities': '🔭',
};

const categoryColors = <String, Color>{
  'solar_system': Color(0xFF6C63FF),
  'exploration': Color(0xFFFF6B6B),
  'stars_galaxies': Color(0xFFFFD93D),
  'curiosities': Color(0xFF00D4AA),
};

class QuizCategoryCard extends StatelessWidget {
  const QuizCategoryCard({
    super.key,
    required this.category,
    required this.highScore,
    required this.onTap,
  });

  final QuizCategory category;
  final int highScore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final color = categoryColors[category.id] ?? AppColors.primary;
    final emoji = categoryEmojis[category.id] ?? '❓';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.quizQuestions(category.questionCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (highScore > 0)
                  Text(
                    t.quizHighScore(highScore, category.questionCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    t.quizNoHighScore,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.4),
                    ),
                  ),
                const SizedBox(height: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: color.withValues(alpha: 0.6)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
