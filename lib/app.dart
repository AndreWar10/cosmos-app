import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/main_page.dart';

class CosmosApp extends StatelessWidget {
  const CosmosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const MainPage(),
      },
    );
  }
}
