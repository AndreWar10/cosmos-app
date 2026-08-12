import '../../../../core/network/app_network.dart';
import '../models/planet_info_model.dart';

abstract class PlanetRemoteDataSource {
  Future<List<PlanetInfoModel>> getAllPlanets();
}

class PlanetRemoteDataSourceImpl implements PlanetRemoteDataSource {
  const PlanetRemoteDataSourceImpl(this._network);

  final AppNetwork _network;

  @override
  Future<List<PlanetInfoModel>> getAllPlanets() async {
    final response = await _network.get<Map<String, dynamic>>(
      '/api/solar-system',
    );
    final data = response.data!['data'] as List<dynamic>;
    return data
        .map((e) => PlanetInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
