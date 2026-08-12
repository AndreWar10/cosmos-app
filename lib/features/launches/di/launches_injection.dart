import 'package:get_it/get_it.dart';

import '../../../core/network/app_network.dart';
import '../data/datasources/launches_remote_datasource.dart';
import '../data/repositories/launches_repository_impl.dart';
import '../domain/repositories/launches_repository.dart';
import '../domain/usecases/get_launches_usecase.dart';
import '../domain/usecases/get_next_launch_usecase.dart';
import '../presentation/bloc/launches_bloc.dart';

void registerLaunchesFeature(GetIt sl) {
  // Data
  sl.registerLazySingleton<LaunchesRemoteDataSource>(
    () => LaunchesRemoteDataSourceImpl(sl<AppNetwork>()),
  );
  sl.registerLazySingleton<LaunchesRepository>(
    () => LaunchesRepositoryImpl(sl<LaunchesRemoteDataSource>()),
  );

  // Domain
  sl.registerLazySingleton(() => GetLaunchesUseCase(sl<LaunchesRepository>()));
  sl.registerLazySingleton(
    () => GetNextLaunchUseCase(sl<LaunchesRepository>()),
  );

  // Presentation
  sl.registerFactory(() => LaunchesBloc(sl<GetLaunchesUseCase>()));
}
