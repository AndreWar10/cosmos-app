class PlanetInfo {
  const PlanetInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.resume,
    required this.features,
    required this.satellites,
  });

  final String id;
  final String name;
  final String type;
  final String resume;
  final PlanetFeatures features;
  final PlanetSatellites satellites;
}

class PlanetFeatures {
  const PlanetFeatures({
    required this.orbitalPeriod,
    required this.orbitalSpeed,
    required this.rotationDuration,
    required this.radius,
    required this.diameter,
    required this.sunDistance,
    required this.temperature,
    required this.gravity,
    required this.oneWayLightToTheSun,
  });

  final List<String> orbitalPeriod;
  final String orbitalSpeed;
  final String rotationDuration;
  final String radius;
  final String diameter;
  final String sunDistance;
  final String temperature;
  final String gravity;
  final String oneWayLightToTheSun;
}

class PlanetSatellites {
  const PlanetSatellites({
    required this.number,
    required this.names,
  });

  final int number;
  final List<String> names;
}
