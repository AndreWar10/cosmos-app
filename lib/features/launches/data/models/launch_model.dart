import '../../domain/entities/launch.dart';

class LaunchLinksModel extends LaunchLinks {
  const LaunchLinksModel({
    super.patchSmall,
    super.patchLarge,
    super.webcast,
    super.wikipedia,
    super.article,
    super.flickrOriginal,
  });

  factory LaunchLinksModel.fromJson(Map<String, dynamic> json) {
    final patch = json['patch'] as Map<String, dynamic>? ?? {};
    final flickr = json['flickr'] as Map<String, dynamic>? ?? {};
    final originals = flickr['original'] as List<dynamic>? ?? [];

    return LaunchLinksModel(
      patchSmall: patch['small'] as String?,
      patchLarge: patch['large'] as String?,
      webcast: json['webcast'] as String?,
      wikipedia: json['wikipedia'] as String?,
      article: json['article'] as String?,
      flickrOriginal: originals.cast<String>(),
    );
  }
}

class LaunchModel extends Launch {
  const LaunchModel({
    required super.id,
    required super.name,
    required super.flightNumber,
    required super.dateUtc,
    required super.success,
    required super.upcoming,
    required super.details,
    required super.rocket,
    required super.launchpad,
    required super.links,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> json) {
    return LaunchModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      flightNumber: json['flightNumber'] as int? ?? 0,
      dateUtc: DateTime.parse(json['dateUtc'] as String),
      success: json['success'] as bool?,
      upcoming: json['upcoming'] as bool? ?? false,
      details: json['details'] as String?,
      rocket: json['rocket'] as String? ?? '',
      launchpad: json['launchpad'] as String? ?? '',
      links: LaunchLinksModel.fromJson(
        json['links'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
