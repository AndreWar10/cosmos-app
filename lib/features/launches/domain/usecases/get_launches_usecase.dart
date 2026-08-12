import '../repositories/launches_repository.dart';

class GetLaunchesUseCase {
  const GetLaunchesUseCase(this._repository);

  final LaunchesRepository _repository;

  Future<LaunchesResult> call({
    int limit = 20,
    int offset = 0,
    bool? upcoming,
    String? status,
  }) {
    return _repository.getLaunches(
      limit: limit,
      offset: offset,
      upcoming: upcoming,
      status: status,
    );
  }
}
