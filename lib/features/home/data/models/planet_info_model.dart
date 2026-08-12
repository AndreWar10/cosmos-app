import '../../domain/entities/planet_info.dart';

class PlanetInfoModel extends PlanetInfo {
  const PlanetInfoModel({
    required super.id,
    required super.name,
    required super.type,
    required super.resume,
    required super.features,
    required super.satellites,
  });

  factory PlanetInfoModel.fromJson(Map<String, dynamic> json) {
    final featuresJson = json['features'] as Map<String, dynamic>? ?? {};
    final satellitesJson =
        featuresJson['satellites'] as Map<String, dynamic>? ?? {};

    final orbitalPeriod = (featuresJson['orbitalPeriod'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final satNames = (satellitesJson['names'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];

    return PlanetInfoModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      resume: json['resume'] as String? ?? '',
      features: PlanetFeatures(
        orbitalPeriod: orbitalPeriod,
        orbitalSpeed: featuresJson['orbitalSpeed'] as String? ?? '',
        rotationDuration: featuresJson['rotationDuration'] as String? ?? '',
        radius: featuresJson['radius'] as String? ?? '',
        diameter: featuresJson['Diameter'] as String? ?? '',
        sunDistance: featuresJson['sunDistance'] as String? ?? '',
        temperature: featuresJson['temperature'] as String? ?? '',
        gravity: featuresJson['gravity'] as String? ?? '',
        oneWayLightToTheSun:
            featuresJson['oneWayLightToTheSun'] as String? ?? '',
      ),
      satellites: PlanetSatellites(
        number: satellitesJson['number'] as int? ?? 0,
        names: satNames,
      ),
    );
  }
}
