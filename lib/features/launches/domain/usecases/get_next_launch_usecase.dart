import '../entities/launch.dart';
import '../repositories/launches_repository.dart';

class GetNextLaunchUseCase {
  const GetNextLaunchUseCase(this._repository);

  final LaunchesRepository _repository;

  Future<Launch> call() => _repository.getNextLaunch();
}
