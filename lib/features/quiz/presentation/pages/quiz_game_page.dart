import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../cubit/quiz_game_cubit.dart';
import '../widgets/quiz_game_widgets.dart';
import 'quiz_result_page.dart';

void _showQuizExitDialog(BuildContext context) {
  final t = context.translate;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(t.quizExitTitle),
      content: Text(t.quizExitMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(t.quizExitCancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).pop();
          },
          child: Text(t.quizExitConfirm),
        ),
      ],
    ),
  );
}

class QuizGamePage extends StatelessWidget {
  const QuizGamePage({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuizGameCubit>()..start(categoryId: categoryId),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<QuizGameCubit, QuizGameState>(
          listener: (context, state) {
            if (state is QuizGameFinished) {
              HapticFeedback.heavyImpact();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => QuizResultPage(
                    result: state.result,
                    isNewRecord: state.isNewRecord,
                  ),
                ),
              );
            }
            if (state is QuizGamePlaying && state.answered) {
              final correct =
                  state.selectedIndex == state.currentQuestion.correctIndex;
              if (correct) {
                HapticFeedback.lightImpact();
              } else {
                HapticFeedback.heavyImpact();
              }
            }
            if (state is QuizGamePlaying &&
                state.answered &&
                state.secondsLeft == 0 &&
                state.selectedIndex == null) {
              HapticFeedback.vibrate();
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          final state = context.read<QuizGameCubit>().state;
          if (state is QuizGamePlaying) {
            _showQuizExitDialog(context);
          } else {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          body: BlocBuilder<QuizGameCubit, QuizGameState>(
            builder: (context, state) {
              return switch (state) {
                QuizGameLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                QuizGamePlaying() => _PlayingView(state: state),
                QuizGameFinished() => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _PlayingView extends StatelessWidget {
  const _PlayingView({required this.state});

  final QuizGamePlaying state;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final q = state.currentQuestion;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QuizTopBar(
              state: state,
              onClose: () => _showQuizExitDialog(context),
            ),
            const SizedBox(height: 8),
            QuizTimerBar(
              secondsLeft: state.secondsLeft,
              maxSeconds: 30,
              answered: state.answered,
            ),
            const SizedBox(height: 28),
            Text(
              q.question,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(q.options.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: QuizOptionButton(
                  text: q.options[i],
                  index: i,
                  state: state,
                  onTap: state.answered
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          context.read<QuizGameCubit>().selectAnswer(i);
                        },
                ),
              );
            }),
            const Spacer(),
            if (state.answered) ...[
              QuizExplanationCard(
                question: q,
                selectedIndex: state.selectedIndex,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.read<QuizGameCubit>().nextQuestion();
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    state.isLast ? t.quizFinish : t.quizNext,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
