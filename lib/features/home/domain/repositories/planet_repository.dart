import '../entities/planet_info.dart';

abstract class PlanetRepository {
  Future<PlanetInfo?> getPlanetInfo(String name);
}
