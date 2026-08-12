import '../../../../core/network/app_network.dart';
import '../models/news_response_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getNews({
    int limit = 20,
    int offset = 0,
    String? search,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  const NewsRemoteDataSourceImpl(this._network);

  final AppNetwork _network;

  @override
  Future<NewsResponseModel> getNews({
    int limit = 20,
    int offset = 0,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _network.get<Map<String, dynamic>>(
      '/api/news',
      queryParameters: queryParams,
    );

    return NewsResponseModel.fromJson(response.data!);
  }
}
