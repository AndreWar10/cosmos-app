import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/quiz_question.dart';
import '../cubit/quiz_game_cubit.dart';

class QuizTopBar extends StatelessWidget {
  const QuizTopBar({
    super.key,
    required this.state,
    required this.onClose,
  });

  final QuizGamePlaying state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            t.quizQuestionOf(
              state.currentIndex + 1,
              state.totalQuestions,
            ),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded,
                  size: 16, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text(
                '${state.correctCount}',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuizTimerBar extends StatelessWidget {
  const QuizTimerBar({
    super.key,
    required this.secondsLeft,
    required this.maxSeconds,
    required this.answered,
  });

  final int secondsLeft;
  final int maxSeconds;
  final bool answered;

  @override
  Widget build(BuildContext context) {
    final progress = secondsLeft / maxSeconds;
    final color = secondsLeft <= 5
        ? AppColors.accent
        : secondsLeft <= 10
            ? const Color(0xFFFFD93D)
            : AppColors.secondary;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(
              answered ? color.withValues(alpha: 0.4) : color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${secondsLeft}s',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: answered ? 0.4 : 1.0),
            ),
          ),
        ),
      ],
    );
  }
}

class QuizOptionButton extends StatelessWidget {
  const QuizOptionButton({
    super.key,
    required this.text,
    required this.index,
    required this.state,
    this.onTap,
  });

  final String text;
  final int index;
  final QuizGamePlaying state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final q = state.currentQuestion;
    final isCorrect = index == q.correctIndex;
    final isSelected = state.selectedIndex == index;
    final answered = state.answered;

    Color bg;
    Color border;
    Color textColor;

    if (!answered) {
      bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
      border = isDark ? AppColors.darkDivider : AppColors.lightDivider;
      textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    } else if (isCorrect) {
      bg = AppColors.secondary.withValues(alpha: 0.12);
      border = AppColors.secondary;
      textColor = AppColors.secondary;
    } else if (isSelected && !isCorrect) {
      bg = AppColors.accent.withValues(alpha: 0.12);
      border = AppColors.accent;
      textColor = AppColors.accent;
    } else {
      bg = isDark
          ? AppColors.darkSurface.withValues(alpha: 0.5)
          : AppColors.lightSurface.withValues(alpha: 0.5);
      border = isDark
          ? AppColors.darkDivider.withValues(alpha: 0.3)
          : AppColors.lightDivider.withValues(alpha: 0.3);
      textColor = (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
          .withValues(alpha: 0.4);
    }

    IconData? trailing;
    if (answered && isCorrect) {
      trailing = Icons.check_circle_rounded;
    } else if (answered && isSelected && !isCorrect) {
      trailing = Icons.cancel_rounded;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: answered && (isCorrect || isSelected) ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: border.withValues(alpha: 0.12),
                border: Border.all(color: border),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight:
                      answered && (isCorrect || isSelected) ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (trailing != null)
              Icon(trailing, color: textColor, size: 22),
          ],
        ),
      ),
    );
  }
}

class QuizExplanationCard extends StatelessWidget {
  const QuizExplanationCard({
    super.key,
    required this.question,
    required this.selectedIndex,
  });

  final QuizQuestion question;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final isCorrect = selectedIndex == question.correctIndex;
    final timedOut = selectedIndex == null;

    final String title;
    final Color color;
    final IconData icon;

    if (timedOut) {
      title = t.quizTimeUp;
      color = AppColors.accent;
      icon = Icons.timer_off_rounded;
    } else if (isCorrect) {
      title = t.quizCorrect;
      color = AppColors.secondary;
      icon = Icons.check_circle_rounded;
    } else {
      title = t.quizWrong;
      color = AppColors.accent;
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
