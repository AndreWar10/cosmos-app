import '../entities/planet_info.dart';

abstract class PlanetRepository {
  PlanetInfo? getPlanetInfo(String planetKey);
}
