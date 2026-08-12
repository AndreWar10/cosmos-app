import 'package:get_it/get_it.dart';

import '../../../core/network/app_network.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_apod_usecase.dart';
import '../presentation/cubit/home_cubit.dart';
import '../../../features/news/domain/usecases/get_news_usecase.dart';

void registerHomeFeature(GetIt sl) {
  // Data
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<AppNetwork>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  // Domain
  sl.registerLazySingleton(() => GetApodUseCase(sl<HomeRepository>()));

  // Presentation
  sl.registerFactory(
    () => HomeCubit(sl<GetApodUseCase>(), sl<GetNewsUseCase>()),
  );
}
