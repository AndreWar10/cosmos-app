import '../../domain/entities/apod.dart';

class ApodModel extends Apod {
  const ApodModel({
    required super.date,
    required super.title,
    required super.explanation,
    required super.url,
    required super.mediaType,
    super.hdUrl,
    super.copyright,
    super.thumbnailUrl,
  });

  factory ApodModel.fromJson(Map<String, dynamic> json) {
    return ApodModel(
      date: json['date'] as String? ?? '',
      title: json['title'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      url: json['url'] as String? ?? '',
      mediaType: json['mediaType'] as String? ?? 'image',
      hdUrl: json['hdUrl'] as String?,
      copyright: json['copyright'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }
}
