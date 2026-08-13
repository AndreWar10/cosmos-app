import 'package:get_it/get_it.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/network/app_network.dart';
import '../../../features/launches/domain/usecases/get_launches_usecase.dart';
import '../../../features/news/domain/usecases/get_news_usecase.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../data/datasources/observatory_local_datasource.dart';
import '../data/datasources/planet_local_datasource.dart';
import '../data/repositories/home_repository_impl.dart';
import '../data/repositories/planet_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/repositories/planet_repository.dart';
import '../domain/usecases/get_apod_usecase.dart';
import '../domain/usecases/get_planet_info_usecase.dart';
import '../../apod/presentation/cubit/apod_detail_cubit.dart';
import '../../solar_system/presentation/cubit/planet_detail_cubit.dart';
import '../presentation/cubit/home_cubit.dart';

void registerHomeFeature(GetIt sl) {
  // Data
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<AppNetwork>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );
  sl.registerLazySingleton<PlanetLocalDataSource>(
    () => PlanetLocalDataSourceImpl(sl<LocaleProvider>()),
  );
  sl.registerLazySingleton<PlanetRepository>(
    () => PlanetRepositoryImpl(sl<PlanetLocalDataSource>()),
  );
  sl.registerLazySingleton<ObservatoryLocalDataSource>(
    () => ObservatoryLocalDataSourceImpl(sl<LocaleProvider>()),
  );

  // Domain
  sl.registerLazySingleton(() => GetApodUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(
    () => GetPlanetInfoUseCase(sl<PlanetRepository>()),
  );

  // Presentation
  sl.registerFactory(
    () => HomeCubit(
      sl<GetApodUseCase>(),
      sl<GetNewsUseCase>(),
      sl<GetLaunchesUseCase>(),
      sl<ObservatoryLocalDataSource>(),
    ),
  );
  sl.registerFactory(
    () => ApodDetailCubit(sl<GetApodUseCase>()),
  );
  sl.registerFactory(
    () => PlanetDetailCubit(sl<GetPlanetInfoUseCase>()),
  );
}
