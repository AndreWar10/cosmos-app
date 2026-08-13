import '../../../../core/locale/locale_provider.dart';
import '../../domain/entities/planet_info.dart';
import 'solar_system_data.dart';

abstract class PlanetLocalDataSource {
  PlanetInfo? getByKey(String planetKey);
  List<PlanetInfo> getAll();
}

const _keyToIndex = <String, int>{
  'sun': 0,
  'mercury': 1,
  'venus': 2,
  'earth': 3,
  'mars': 4,
  'jupiter': 5,
  'saturn': 6,
  'uranus': 7,
  'neptune': 8,
};

class PlanetLocalDataSourceImpl implements PlanetLocalDataSource {
  const PlanetLocalDataSourceImpl(this._localeProvider);

  final LocaleProvider _localeProvider;

  List<PlanetInfo> get _planets =>
      solarSystemData[_localeProvider.isPortuguese ? 'pt' : 'en']!;

  @override
  PlanetInfo? getByKey(String planetKey) {
    final index = _keyToIndex[planetKey.toLowerCase()];
    if (index == null || index >= _planets.length) return null;
    return _planets[index];
  }

  @override
  List<PlanetInfo> getAll() => _planets;
}
