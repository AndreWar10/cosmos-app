import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cache/app_cache.dart';
import '../env/app_env.dart';
import '../locale/locale_provider.dart';
import '../network/app_network.dart';
import '../../features/home/di/home_injection.dart';
import '../../features/launches/di/launches_injection.dart';
import '../../features/news/di/news_injection.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Cache
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<AppCache>(() => AppCacheImpl(prefs));

  // Core
  sl.registerLazySingleton<AppEnv>(() => AppEnvImpl());

  final initialLocale = _resolveInitialLocale(sl<AppCache>());
  sl.registerLazySingleton<LocaleProvider>(
    () => LocaleProvider(initialLocale),
  );

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

String _resolveInitialLocale(AppCache cache) {
  const supported = {'pt', 'en'};
  final saved = cache.getString('app_locale');
  if (saved != null && supported.contains(saved)) return saved;
  final system = PlatformDispatcher.instance.locale.languageCode;
  return supported.contains(system) ? system : 'en';
}
