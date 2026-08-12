import '../../domain/entities/launch.dart';

sealed class LaunchesState {}

class LaunchesInitial extends LaunchesState {}

class LaunchesLoading extends LaunchesState {}

class LaunchesLoaded extends LaunchesState {
  LaunchesLoaded({
    required this.launches,
    required this.count,
    this.upcomingFilter,
    this.statusFilter,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  final List<Launch> launches;
  final int count;
  final bool? upcomingFilter;
  final String? statusFilter;
  final bool hasReachedMax;
  final bool isLoadingMore;

  LaunchesLoaded copyWith({
    List<Launch>? launches,
    int? count,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return LaunchesLoaded(
      launches: launches ?? this.launches,
      count: count ?? this.count,
      upcomingFilter: upcomingFilter,
      statusFilter: statusFilter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class LaunchesError extends LaunchesState {
  LaunchesError(this.message);
  final String message;
}
