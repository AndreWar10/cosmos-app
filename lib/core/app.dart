import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../i18n/generated/app_localizations.dart';
import 'cache/app_cache.dart';
import 'di/injection_container.dart';
import 'locale/locale_cubit.dart';
import 'locale/locale_provider.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';

class CosmosApp extends StatelessWidget {
  const CosmosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cache = sl<AppCache>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(cache)),
        BlocProvider(
          create: (_) => LocaleCubit(sl<LocaleProvider>(), cache),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                title: 'Cosmos',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                initialRoute: AppRoutes.initial,
                routes: AppRoutes.routes,
              );
            },
          );
        },
      ),
    );
  }
}
