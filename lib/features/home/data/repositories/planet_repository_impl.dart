import '../../domain/entities/planet_info.dart';
import '../../domain/repositories/planet_repository.dart';
import '../datasources/planet_remote_datasource.dart';
import '../models/planet_info_model.dart';

class PlanetRepositoryImpl implements PlanetRepository {
  PlanetRepositoryImpl(this._dataSource);

  final PlanetRemoteDataSource _dataSource;

  List<PlanetInfoModel>? _cache;

  @override
  Future<PlanetInfo?> getPlanetInfo(String name) async {
    _cache ??= await _dataSource.getAllPlanets();
    return _cache!.cast<PlanetInfo?>().firstWhere(
          (p) => p!.name.toLowerCase() == name.toLowerCase(),
          orElse: () => null,
        );
  }
}
