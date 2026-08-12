import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';
import 'main_page.dart';

class CosmosApp extends StatelessWidget {
  const CosmosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Cosmos',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            initialRoute: AppRoutes.home,
            routes: {
              AppRoutes.home: (_) => const MainPage(),
            },
          );
        },
      ),
    );
  }
}
