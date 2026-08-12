import 'package:flutter/material.dart';

import 'widgets/app_bottom_navigation.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/launches/presentation/pages/launches_page.dart';
import '../features/news/presentation/pages/news_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final _pages = const [
    HomePage(),
    NewsPage(),
    LaunchesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
