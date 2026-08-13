import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../domain/entities/quiz_category.dart';
import '../../domain/entities/quiz_stats.dart';
import '../cubit/quiz_hub_cubit.dart';
import '../widgets/quiz_category_card.dart';
import '../widgets/quiz_quick_play_card.dart';
import '../widgets/quiz_stats_row.dart';
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
          QuizQuickPlayCard(
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
            QuizStatsRow(stats: stats),
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
                child: QuizCategoryCard(
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
    HapticFeedback.selectionClick();
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
