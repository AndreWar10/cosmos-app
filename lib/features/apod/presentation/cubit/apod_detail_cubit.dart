import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/apod.dart';
import '../../../home/domain/usecases/get_apod_usecase.dart';

class ApodDetailState {
  const ApodDetailState({
    required this.apod,
    required this.currentDate,
    this.isLoading = false,
    this.error,
  });

  final Apod apod;
  final DateTime currentDate;
  final bool isLoading;
  final String? error;

  bool get canGoForward {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return currentDate.isBefore(todayDate);
  }

  ApodDetailState copyWith({
    Apod? apod,
    DateTime? currentDate,
    bool? isLoading,
    String? error,
  }) {
    return ApodDetailState(
      apod: apod ?? this.apod,
      currentDate: currentDate ?? this.currentDate,
      isLoading: isLoading ?? false,
      error: error,
    );
  }
}

class ApodDetailCubit extends Cubit<ApodDetailState> {
  ApodDetailCubit(this._getApodUseCase)
      : super(ApodDetailState(
          apod: const Apod(
            date: '',
            title: '',
            explanation: '',
            url: '',
            mediaType: 'image',
          ),
          currentDate: DateTime.now(),
        ));

  final GetApodUseCase _getApodUseCase;

  void init(Apod apod) {
    final parts = apod.date.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    emit(ApodDetailState(apod: apod, currentDate: date));
  }

  Future<void> goToPreviousDay() async {
    final prevDate = state.currentDate.subtract(const Duration(days: 1));
    await _loadDate(prevDate);
  }

  Future<void> goToNextDay() async {
    if (!state.canGoForward) return;
    final nextDate = state.currentDate.add(const Duration(days: 1));
    await _loadDate(nextDate);
  }

  Future<void> _loadDate(DateTime date) async {
    emit(state.copyWith(isLoading: true, currentDate: date));
    try {
      final dateStr = '${date.year}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
      final apod = await _getApodUseCase(date: dateStr);
      emit(state.copyWith(apod: apod, currentDate: date));
    } catch (_) {
      emit(state.copyWith(
        error: 'Failed to load APOD',
        currentDate: state.currentDate,
      ));
    }
  }
}
