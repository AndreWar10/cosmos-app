import '../../domain/entities/planet_info.dart';
import '../../domain/repositories/planet_repository.dart';
import '../datasources/planet_local_datasource.dart';

class PlanetRepositoryImpl implements PlanetRepository {
  const PlanetRepositoryImpl(this._dataSource);

  final PlanetLocalDataSource _dataSource;

  @override
  PlanetInfo? getPlanetInfo(String planetKey) =>
      _dataSource.getByKey(planetKey);
}
