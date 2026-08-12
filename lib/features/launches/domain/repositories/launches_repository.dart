import '../entities/launch.dart';

typedef LaunchesResult = ({List<Launch> launches, int count});

abstract class LaunchesRepository {
  Future<LaunchesResult> getLaunches({
    int limit = 20,
    int offset = 0,
    bool? upcoming,
    String? status,
  });
  Future<Launch> getNextLaunch();
  Future<Launch> getLatestLaunch();
}
