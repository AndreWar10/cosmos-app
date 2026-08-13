import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/network_error_helper.dart';
import '../../domain/usecases/get_launches_usecase.dart';
import 'launches_event.dart';
import 'launches_state.dart';

class LaunchesBloc extends Bloc<LaunchesEvent, LaunchesState> {
  LaunchesBloc(this._getLaunchesUseCase) : super(LaunchesInitial()) {
    on<LaunchesFetched>(_onFetched);
    on<LaunchesNextPageFetched>(_onNextPage);
    on<LaunchesFilterChanged>(_onFilterChanged);
  }

  final GetLaunchesUseCase _getLaunchesUseCase;

  static const _pageSize = 20;
  bool? _upcomingFilter = true;
  String? _statusFilter;

  Future<void> _onFetched(
    LaunchesFetched event,
    Emitter<LaunchesState> emit,
  ) async {
    emit(LaunchesLoading());
    try {
      final result = await _getLaunchesUseCase(
        limit: _pageSize,
        upcoming: _upcomingFilter,
        status: _statusFilter,
      );
      emit(LaunchesLoaded(
        launches: result.launches,
        count: result.count,
        upcomingFilter: _upcomingFilter,
        statusFilter: _statusFilter,
        hasReachedMax: result.launches.length >= result.count,
      ));
    } catch (e) {
      emit(LaunchesError(
        'Failed to load launches',
        isNoInternet: isConnectionError(e),
      ));
    }
  }

  Future<void> _onNextPage(
    LaunchesNextPageFetched event,
    Emitter<LaunchesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! LaunchesLoaded || currentState.hasReachedMax) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final result = await _getLaunchesUseCase(
        limit: _pageSize,
        offset: currentState.launches.length,
        upcoming: _upcomingFilter,
        status: _statusFilter,
      );

      final allLaunches = [...currentState.launches, ...result.launches];

      emit(LaunchesLoaded(
        launches: allLaunches,
        count: result.count,
        upcomingFilter: _upcomingFilter,
        statusFilter: _statusFilter,
        hasReachedMax: allLaunches.length >= result.count,
      ));
    } catch (_) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFilterChanged(
    LaunchesFilterChanged event,
    Emitter<LaunchesState> emit,
  ) async {
    _upcomingFilter = event.upcoming;
    _statusFilter = event.status;
    add(LaunchesFetched());
  }
}
