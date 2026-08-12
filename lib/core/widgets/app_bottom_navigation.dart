import 'package:flutter/material.dart';

import '../extensions/build_context_extensions.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.explore_outlined),
          activeIcon: const Icon(Icons.explore),
          label: t.navHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.article_outlined),
          activeIcon: const Icon(Icons.article),
          label: t.navNews,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.rocket_launch_outlined),
          activeIcon: const Icon(Icons.rocket_launch),
          label: t.navLaunches,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: t.navSettings,
        ),
      ],
    );
  }
}
