import 'package:flutter/material.dart';

import '../../features/home/domain/entities/apod.dart';
import '../../features/home/domain/entities/planet.dart';
import '../../features/home/presentation/pages/apod_detail_page.dart';
import '../../features/home/presentation/pages/planet_detail_page.dart';
import '../../features/launches/domain/entities/launch.dart';
import '../../features/launches/presentation/pages/launch_detail_page.dart';
import '../../features/launches/presentation/pages/launches_page.dart';
import '../../features/news/domain/entities/article.dart';
import '../../features/news/presentation/pages/news_detail_page.dart';
import '../navigation/presentation/pages/root_page.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String news = '/news';
  static const String apodDetail = '/apod/detail';
  static const String launches = '/launches';
  static const String launchDetail = '/launches/detail';
  static const String newsDetail = '/news/detail';
  static const String planetDetail = '/planets/detail';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const RootPage(),
    apodDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Apod) {
        return ApodDetailPage(apod: args);
      }
      return const Scaffold(
        body: Center(child: Text('Invalid APOD data')),
      );
    },
    launches: (context) => const LaunchesPage(),
    newsDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Article) {
        return NewsDetailPage(article: args);
      }
      return const Scaffold(
        body: Center(child: Text('Invalid article data')),
      );
    },
    launchDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Launch) {
        return LaunchDetailPage(launch: args);
      }
      return const Scaffold(
        body: Center(child: Text('Invalid launch data')),
      );
    },
    planetDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Planet) {
        return PlanetDetailPage(planet: args);
      }
      return const Scaffold(
        body: Center(child: Text('Invalid planet data')),
      );
    },
  };
}
