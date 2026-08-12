import '../entities/article.dart';

abstract class NewsRepository {
  Future<({List<Article> articles, int count})> getNews({
    int limit = 20,
    int offset = 0,
    String? search,
  });
}
