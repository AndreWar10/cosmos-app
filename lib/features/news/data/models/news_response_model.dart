import 'article_model.dart';

class NewsResponseModel {
  const NewsResponseModel({
    required this.count,
    required this.articles,
  });

  final int count;
  final List<ArticleModel> articles;

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    return NewsResponseModel(
      count: data['count'] as int,
      articles: results
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
