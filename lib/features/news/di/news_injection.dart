import 'package:get_it/get_it.dart';

import '../../../core/network/app_network.dart';
import '../data/datasources/news_remote_datasource.dart';
import '../data/repositories/news_repository_impl.dart';
import '../domain/repositories/news_repository.dart';
import '../domain/usecases/get_news_usecase.dart';
import '../presentation/bloc/news_bloc.dart';

void registerNewsFeature(GetIt sl) {
  // Data
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl<AppNetwork>()),
  );
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(sl<NewsRemoteDataSource>()),
  );

  // Domain
  sl.registerLazySingleton(() => GetNewsUseCase(sl<NewsRepository>()));

  // Presentation
  sl.registerFactory(() => NewsBloc(sl<GetNewsUseCase>()));
}
