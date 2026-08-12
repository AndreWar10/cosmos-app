import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.url,
    required super.imageUrl,
    required super.newsSite,
    required super.publishedAt,
    required super.featured,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      newsSite: json['newsSite'] as String? ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      featured: json['featured'] as bool? ?? false,
    );
  }
}
