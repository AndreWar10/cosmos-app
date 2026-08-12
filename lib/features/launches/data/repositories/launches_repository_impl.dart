import '../../domain/entities/launch.dart';
import '../../domain/repositories/launches_repository.dart';
import '../datasources/launches_remote_datasource.dart';

class LaunchesRepositoryImpl implements LaunchesRepository {
  const LaunchesRepositoryImpl(this._dataSource);

  final LaunchesRemoteDataSource _dataSource;

  @override
  Future<LaunchesResult> getLaunches({
    int limit = 20,
    int offset = 0,
    bool? upcoming,
    String? status,
  }) async {
    final result = await _dataSource.getLaunches(
      limit: limit,
      offset: offset,
      upcoming: upcoming,
      status: status,
    );
    return (launches: result.launches as List<Launch>, count: result.count);
  }

  @override
  Future<Launch> getNextLaunch() => _dataSource.getNextLaunch();

  @override
  Future<Launch> getLatestLaunch() => _dataSource.getLatestLaunch();
}
