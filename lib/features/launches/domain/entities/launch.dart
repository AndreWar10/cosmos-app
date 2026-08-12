class Launch {
  const Launch({
    required this.id,
    required this.name,
    required this.flightNumber,
    required this.dateUtc,
    required this.success,
    required this.upcoming,
    required this.details,
    required this.rocket,
    required this.launchpad,
    required this.links,
  });

  final String id;
  final String name;
  final int flightNumber;
  final DateTime dateUtc;
  final bool? success;
  final bool upcoming;
  final String? details;
  final String rocket;
  final String launchpad;
  final LaunchLinks links;
}

class LaunchLinks {
  const LaunchLinks({
    this.patchSmall,
    this.patchLarge,
    this.webcast,
    this.wikipedia,
    this.article,
    this.flickrOriginal = const [],
  });

  final String? patchSmall;
  final String? patchLarge;
  final String? webcast;
  final String? wikipedia;
  final String? article;
  final List<String> flickrOriginal;
}
