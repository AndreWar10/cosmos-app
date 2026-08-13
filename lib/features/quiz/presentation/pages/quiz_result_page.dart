import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/quiz_result.dart';
import '../widgets/quiz_score_ring.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({
    super.key,
    required this.result,
    required this.isNewRecord,
  });

  final QuizResult result;
  final bool isNewRecord;

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scoreAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: widget.result.percentage)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final r = widget.result;
    final pct = r.percentage;

    final Color accentColor;
    final String message;
    final IconData icon;

    if (pct >= 0.9) {
      accentColor = AppColors.secondary;
      message = t.quizResultExcellent;
      icon = Icons.emoji_events_rounded;
    } else if (pct >= 0.7) {
      accentColor = const Color(0xFF6C63FF);
      message = t.quizResultGreat;
      icon = Icons.thumb_up_rounded;
    } else if (pct >= 0.5) {
      accentColor = const Color(0xFFFFD93D);
      message = t.quizResultGood;
      icon = Icons.sentiment_satisfied_rounded;
    } else {
      accentColor = AppColors.accent;
      message = t.quizResultKeepTrying;
      icon = Icons.sentiment_dissatisfied_rounded;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(flex: 1),
                AnimatedBuilder(
                  animation: _scoreAnimation,
                  builder: (context, _) {
                    return QuizScoreRing(
                      progress: _scoreAnimation.value,
                      color: accentColor,
                      correct: r.correctAnswers,
                      total: r.totalQuestions,
                    );
                  },
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Icon(icon, size: 36, color: accentColor),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.isNewRecord && r.correctAnswers > 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD93D).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFFD93D).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 18, color: Color(0xFFFFD93D)),
                              const SizedBox(width: 6),
                              Text(
                                t.quizResultNewRecord,
                                style: const TextStyle(
                                  color: Color(0xFFFFD93D),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        t.quizResultScore(r.correctAnswers, r.totalQuestions),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.textTheme.titleMedium?.color
                              ?.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.replay_rounded),
                          label: Text(t.quizPlayAgain),
                          style: FilledButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(t.quizBackToHub),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
