import '../entities/planet_info.dart';
import '../repositories/planet_repository.dart';

class GetPlanetInfoUseCase {
  const GetPlanetInfoUseCase(this._repository);

  final PlanetRepository _repository;

  Future<PlanetInfo?> call(String name) => _repository.getPlanetInfo(name);
}
