import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetNewsUseCase {
  const GetNewsUseCase(this._repository);

  final NewsRepository _repository;

  Future<({List<Article> articles, int count})> call({
    int limit = 20,
    int offset = 0,
    String? search,
  }) {
    return _repository.getNews(
      limit: limit,
      offset: offset,
      search: search,
    );
  }
}
