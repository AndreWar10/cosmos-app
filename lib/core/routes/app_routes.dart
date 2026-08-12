import 'package:flutter/material.dart';

import '../../features/launches/domain/entities/launch.dart';
import '../../features/launches/presentation/pages/launch_detail_page.dart';
import '../navigation/presentation/pages/root_page.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String news = '/news';
  static const String launches = '/launches';
  static const String launchDetail = '/launches/detail';
  static const String planetDetail = '/planets/detail';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const RootPage(),
    launchDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Launch) {
        return LaunchDetailPage(launch: args);
      }
      return const Scaffold(
        body: Center(child: Text('Invalid launch data')),
      );
    },
  };
}
