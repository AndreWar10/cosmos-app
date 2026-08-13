import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/quiz_category.dart';
import '../../domain/entities/quiz_stats.dart';
import '../cubit/quiz_hub_cubit.dart';
import 'quiz_game_page.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuizHubCubit>()..load(),
      child: const _QuizHubView(),
    );
  }
}

class _QuizHubView extends StatelessWidget {
  const _QuizHubView();

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Scaffold(
      appBar: AppBar(title: Text(t.quizTitle)),
      body: BlocBuilder<QuizHubCubit, QuizHubState>(
        builder: (context, state) {
          return switch (state) {
            QuizHubInitial() || QuizHubLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            QuizHubError() => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.white38),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<QuizHubCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            QuizHubLoaded(:final categories, :final stats) =>
              _HubContent(categories: categories, stats: stats),
          };
        },
      ),
    );
  }
}

class _HubContent extends StatelessWidget {
  const _HubContent({required this.categories, required this.stats});

  final List<QuizCategory> categories;
  final QuizStats stats;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QuickPlayCard(
            onTap: () => _startQuiz(context, null),
          ),
          const SizedBox(height: 28),

          if (stats.totalAnswered > 0) ...[
            Text(
              t.quizStatsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _StatsRow(stats: stats),
            const SizedBox(height: 28),
          ],

          Text(
            t.quizCategories,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CategoryCard(
                  category: cat,
                  highScore: stats.highScoreFor(cat.id),
                  onTap: () => _startQuiz(context, cat.id),
                ),
              )),
        ],
      ),
    );
  }

  void _startQuiz(BuildContext context, String? categoryId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizGamePage(categoryId: categoryId),
      ),
    );
    if (context.mounted) {
      context.read<QuizHubCubit>().load();
    }
  }
}

const _categoryIcons = <String, IconData>{
  'public': Icons.public_rounded,
  'rocket_launch': Icons.rocket_launch_rounded,
  'auto_awesome': Icons.auto_awesome_rounded,
  'psychology': Icons.psychology_rounded,
};

const _categoryColors = <String, Color>{
  'solar_system': Color(0xFF6C63FF),
  'exploration': Color(0xFFFF6B6B),
  'stars_galaxies': Color(0xFFFFD93D),
  'curiosities': Color(0xFF00D4AA),
};

class _QuickPlayCard extends StatefulWidget {
  const _QuickPlayCard({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_QuickPlayCard> createState() => _QuickPlayCardState();
}

class _QuickPlayCardState extends State<_QuickPlayCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9F7AEA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final scale = 1.0 + (_pulse.value * 0.12);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                          alpha: 0.2 + (_pulse.value * 0.1)),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(
                              alpha: 0.15 * _pulse.value),
                          blurRadius: 12 * _pulse.value,
                        ),
                      ],
                    ),
                    child: const Icon(
                        Icons.bolt_rounded, size: 32, color: Colors.white),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.quizQuickPlay,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.quizQuickPlayDesc,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final QuizStats stats;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_rounded,
            label: t.quizStatsAnswered,
            value: stats.totalAnswered.toString(),
            color: AppColors.primary,
            surface: surface,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up_rounded,
            label: t.quizStatsCorrectRate,
            value: '${(stats.overallPercentage * 100).toStringAsFixed(0)}%',
            color: AppColors.secondary,
            surface: surface,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.surface,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
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
    final color = _categoryColors[category.id] ?? AppColors.primary;
    final icon = _categoryIcons[category.icon] ?? Icons.quiz_rounded;

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
              child: Icon(icon, color: color, size: 24),
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
