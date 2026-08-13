import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/usecases/get_quiz_questions_usecase.dart';
import '../../domain/usecases/save_quiz_result_usecase.dart';

sealed class QuizGameState {}

class QuizGameLoading extends QuizGameState {}

class QuizGamePlaying extends QuizGameState {
  QuizGamePlaying({
    required this.questions,
    required this.currentIndex,
    required this.selectedIndex,
    required this.answered,
    required this.correctCount,
    required this.secondsLeft,
    required this.categoryId,
  });

  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedIndex;
  final bool answered;
  final int correctCount;
  final int secondsLeft;
  final String categoryId;

  QuizQuestion get currentQuestion => questions[currentIndex];
  bool get isLast => currentIndex >= questions.length - 1;
  int get totalQuestions => questions.length;
}

class QuizGameFinished extends QuizGameState {
  QuizGameFinished({required this.result, required this.isNewRecord});

  final QuizResult result;
  final bool isNewRecord;
}

class QuizGameCubit extends Cubit<QuizGameState> {
  QuizGameCubit(this._getQuestionsUseCase, this._saveResultUseCase)
      : super(QuizGameLoading());

  final GetQuizQuestionsUseCase _getQuestionsUseCase;
  final SaveQuizResultUseCase _saveResultUseCase;

  Timer? _timer;
  int _correctCount = 0;
  int _elapsedSeconds = 0;
  static const _timerDuration = 30;
  static const _quickPlayCount = 10;

  Future<void> start({String? categoryId}) async {
    emit(QuizGameLoading());
    _correctCount = 0;
    _elapsedSeconds = 0;

    var questions = await _getQuestionsUseCase(categoryId: categoryId);
    questions = List.of(questions)..shuffle(Random());

    if (categoryId == null && questions.length > _quickPlayCount) {
      questions = questions.sublist(0, _quickPlayCount);
    }

    emit(QuizGamePlaying(
      questions: questions,
      currentIndex: 0,
      selectedIndex: null,
      answered: false,
      correctCount: 0,
      secondsLeft: _timerDuration,
      categoryId: categoryId ?? 'quick',
    ));

    _startTimer();
  }

  void selectAnswer(int index) {
    final s = state;
    if (s is! QuizGamePlaying || s.answered) return;

    _timer?.cancel();
    final isCorrect = index == s.currentQuestion.correctIndex;
    if (isCorrect) _correctCount++;

    emit(QuizGamePlaying(
      questions: s.questions,
      currentIndex: s.currentIndex,
      selectedIndex: index,
      answered: true,
      correctCount: _correctCount,
      secondsLeft: s.secondsLeft,
      categoryId: s.categoryId,
    ));
  }

  void timeUp() {
    final s = state;
    if (s is! QuizGamePlaying || s.answered) return;

    _timer?.cancel();
    emit(QuizGamePlaying(
      questions: s.questions,
      currentIndex: s.currentIndex,
      selectedIndex: null,
      answered: true,
      correctCount: _correctCount,
      secondsLeft: 0,
      categoryId: s.categoryId,
    ));
  }

  void nextQuestion() {
    final s = state;
    if (s is! QuizGamePlaying) return;

    if (s.isLast) {
      _finishQuiz(s);
      return;
    }

    emit(QuizGamePlaying(
      questions: s.questions,
      currentIndex: s.currentIndex + 1,
      selectedIndex: null,
      answered: false,
      correctCount: _correctCount,
      secondsLeft: _timerDuration,
      categoryId: s.categoryId,
    ));

    _startTimer();
  }

  Future<void> _finishQuiz(QuizGamePlaying s) async {
    _timer?.cancel();

    final result = QuizResult(
      categoryId: s.categoryId,
      totalQuestions: s.totalQuestions,
      correctAnswers: _correctCount,
      timeTakenSeconds: _elapsedSeconds,
    );

    bool isNewRecord = false;
    try {
      await _saveResultUseCase(
        categoryId: s.categoryId,
        score: _correctCount,
        totalQuestions: s.totalQuestions,
      );
      isNewRecord = true;
    } catch (_) {}

    emit(QuizGameFinished(result: result, isNewRecord: isNewRecord));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final s = state;
      if (s is! QuizGamePlaying || s.answered) {
        timer.cancel();
        return;
      }

      _elapsedSeconds++;
      final left = s.secondsLeft - 1;
      if (left <= 0) {
        timer.cancel();
        timeUp();
        return;
      }

      emit(QuizGamePlaying(
        questions: s.questions,
        currentIndex: s.currentIndex,
        selectedIndex: s.selectedIndex,
        answered: s.answered,
        correctCount: s.correctCount,
        secondsLeft: left,
        categoryId: s.categoryId,
      ));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
