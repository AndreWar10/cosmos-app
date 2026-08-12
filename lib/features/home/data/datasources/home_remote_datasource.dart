import '../../../../core/network/app_network.dart';
import '../models/apod_model.dart';

abstract class HomeRemoteDataSource {
  Future<ApodModel> getApod();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._network);

  final AppNetwork _network;

  @override
  Future<ApodModel> getApod() async {
    final response = await _network.get<Map<String, dynamic>>('/api/apod');
    final data = response.data!['data'] as Map<String, dynamic>;
    return ApodModel.fromJson(data);
  }
}
