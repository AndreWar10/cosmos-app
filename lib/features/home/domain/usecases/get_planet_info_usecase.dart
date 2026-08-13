import '../entities/planet_info.dart';
import '../repositories/planet_repository.dart';

class GetPlanetInfoUseCase {
  const GetPlanetInfoUseCase(this._repository);

  final PlanetRepository _repository;

  PlanetInfo? call(String planetKey) => _repository.getPlanetInfo(planetKey);
}
