import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._dataSource);

  final NewsRemoteDataSource _dataSource;

  @override
  Future<({List<Article> articles, int count})> getNews({
    int limit = 20,
    int offset = 0,
    String? search,
  }) async {
    final response = await _dataSource.getNews(
      limit: limit,
      offset: offset,
      search: search,
    );

    return (
      articles: response.articles.cast<Article>(),
      count: response.count,
    );
  }
}
