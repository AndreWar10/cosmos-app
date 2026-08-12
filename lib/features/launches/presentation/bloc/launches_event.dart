sealed class LaunchesEvent {}

class LaunchesFetched extends LaunchesEvent {}

class LaunchesNextPageFetched extends LaunchesEvent {}

class LaunchesFilterChanged extends LaunchesEvent {
  LaunchesFilterChanged({this.upcoming, this.status});
  final bool? upcoming;
  final String? status;
}
