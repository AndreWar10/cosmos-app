import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quiz_category.dart';
import '../../domain/entities/quiz_stats.dart';
import '../../domain/usecases/get_quiz_categories_usecase.dart';
import '../../domain/usecases/get_quiz_stats_usecase.dart';

sealed class QuizHubState {}

class QuizHubInitial extends QuizHubState {}

class QuizHubLoading extends QuizHubState {}

class QuizHubLoaded extends QuizHubState {
  QuizHubLoaded({required this.categories, required this.stats});

  final List<QuizCategory> categories;
  final QuizStats stats;
}

class QuizHubError extends QuizHubState {}

class QuizHubCubit extends Cubit<QuizHubState> {
  QuizHubCubit(this._getCategoriesUseCase, this._getStatsUseCase)
      : super(QuizHubInitial());

  final GetQuizCategoriesUseCase _getCategoriesUseCase;
  final GetQuizStatsUseCase _getStatsUseCase;

  Future<void> load() async {
    emit(QuizHubLoading());
    try {
      final categories = await _getCategoriesUseCase();
      final stats = await _getStatsUseCase();
      emit(QuizHubLoaded(categories: categories, stats: stats));
    } catch (_) {
      emit(QuizHubError());
    }
  }
}
