import '../../../../core/network/app_network.dart';
import '../models/apod_model.dart';

abstract class HomeRemoteDataSource {
  Future<ApodModel> getApod({String? date});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._network);

  final AppNetwork _network;

  @override
  Future<ApodModel> getApod({String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null) queryParams['date'] = date;

    try {
      return await _fetch(queryParams);
    } catch (_) {
      if (date != null) rethrow;

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final fallbackDate = '${yesterday.year}-'
          '${yesterday.month.toString().padLeft(2, '0')}-'
          '${yesterday.day.toString().padLeft(2, '0')}';

      return _fetch({'date': fallbackDate});
    }
  }

  Future<ApodModel> _fetch(Map<String, dynamic> queryParams) async {
    final response = await _network.get<Map<String, dynamic>>(
      '/api/apod',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return ApodModel.fromJson(data);
  }
}
