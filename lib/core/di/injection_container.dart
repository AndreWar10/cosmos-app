import 'package:get_it/get_it.dart';

import '../env/app_env.dart';
import '../locale/locale_provider.dart';
import '../network/app_network.dart';
import '../../features/home/di/home_injection.dart';
import '../../features/launches/di/launches_injection.dart';
import '../../features/news/di/news_injection.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Core
  sl.registerLazySingleton<AppEnv>(() => AppEnvImpl());
  sl.registerLazySingleton<LocaleProvider>(() => LocaleProvider());
  sl.registerLazySingleton<AppNetwork>(
    () => AppNetworkImpl(
      baseUrl: sl<AppEnv>().baseUrl,
      localeProvider: sl<LocaleProvider>(),
    ),
  );

  // Features
  registerNewsFeature(sl);
  registerLaunchesFeature(sl);
  registerHomeFeature(sl);
}
