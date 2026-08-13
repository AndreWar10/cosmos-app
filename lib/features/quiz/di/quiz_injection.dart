import 'package:get_it/get_it.dart';

import '../../../core/cache/app_cache.dart';
import '../../../core/locale/locale_provider.dart';
import '../data/datasources/quiz_local_datasource.dart';
import '../data/repositories/quiz_repository_impl.dart';
import '../data/services/quiz_sound_service.dart';
import '../domain/repositories/quiz_repository.dart';
import '../domain/usecases/get_quiz_categories_usecase.dart';
import '../domain/usecases/get_quiz_questions_usecase.dart';
import '../domain/usecases/get_quiz_stats_usecase.dart';
import '../domain/usecases/save_quiz_result_usecase.dart';
import '../presentation/cubit/quiz_game_cubit.dart';
import '../presentation/cubit/quiz_hub_cubit.dart';

void registerQuizFeature(GetIt sl) {
  sl.registerLazySingleton<QuizLocalDataSource>(
    () => QuizLocalDataSourceImpl(sl<LocaleProvider>(), sl<AppCache>()),
  );
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(sl<QuizLocalDataSource>()),
  );
  sl.registerLazySingleton(() => QuizSoundService(sl<AppCache>()));

  sl.registerLazySingleton(
    () => GetQuizCategoriesUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton(
    () => GetQuizQuestionsUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton(() => GetQuizStatsUseCase(sl<QuizRepository>()));
  sl.registerLazySingleton(() => SaveQuizResultUseCase(sl<QuizRepository>()));

  sl.registerFactory(
    () => QuizHubCubit(
      sl<GetQuizCategoriesUseCase>(),
      sl<GetQuizStatsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => QuizGameCubit(
      sl<GetQuizQuestionsUseCase>(),
      sl<SaveQuizResultUseCase>(),
      sl<QuizSoundService>(),
    ),
  );
}
