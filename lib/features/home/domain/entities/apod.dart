class Apod {
  const Apod({
    required this.date,
    required this.title,
    required this.explanation,
    required this.url,
    required this.mediaType,
    this.hdUrl,
    this.copyright,
    this.thumbnailUrl,
  });

  final String date;
  final String title;
  final String explanation;
  final String url;
  final String mediaType;
  final String? hdUrl;
  final String? copyright;
  final String? thumbnailUrl;

  bool get isImage => mediaType == 'image';
  bool get isVideo => mediaType == 'video';

  String get displayImageUrl => thumbnailUrl ?? url;
}
