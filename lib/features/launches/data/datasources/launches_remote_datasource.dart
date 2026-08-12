import '../../../../core/network/app_network.dart';
import '../models/launch_model.dart';

typedef LaunchesDataResult = ({List<LaunchModel> launches, int count});

abstract class LaunchesRemoteDataSource {
  Future<LaunchesDataResult> getLaunches({
    int limit = 20,
    int offset = 0,
    bool? upcoming,
    String? status,
  });
  Future<LaunchModel> getNextLaunch();
  Future<LaunchModel> getLatestLaunch();
}

class LaunchesRemoteDataSourceImpl implements LaunchesRemoteDataSource {
  const LaunchesRemoteDataSourceImpl(this._network);

  final AppNetwork _network;

  @override
  Future<LaunchesDataResult> getLaunches({
    int limit = 20,
    int offset = 0,
    bool? upcoming,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (upcoming != null) queryParams['upcoming'] = upcoming;
    if (status != null) queryParams['status'] = status;

    final response = await _network.get<Map<String, dynamic>>(
      '/api/launches',
      queryParameters: queryParams,
    );

    final data = response.data!['data'] as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    final count = data['count'] as int;

    return (
      launches: results
          .map((e) => LaunchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: count,
    );
  }

  @override
  Future<LaunchModel> getNextLaunch() async {
    final response = await _network.get<Map<String, dynamic>>(
      '/api/launches',
      queryParameters: {'mode': 'next'},
    );

    final data = response.data!['data'] as Map<String, dynamic>;
    return LaunchModel.fromJson(data);
  }

  @override
  Future<LaunchModel> getLatestLaunch() async {
    final response = await _network.get<Map<String, dynamic>>(
      '/api/launches',
      queryParameters: {'mode': 'latest'},
    );

    final data = response.data!['data'] as Map<String, dynamic>;
    return LaunchModel.fromJson(data);
  }
}
