import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/launches/presentation/pages/launches_page.dart';
import '../../../../features/news/presentation/pages/news_page.dart';
import '../../../../features/settings/presentation/pages/settings_page.dart';
import '../../../widgets/app_bottom_navigation.dart';
import '../cubit/navigation_cubit.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  static const _pages = [
    HomePage(),
    NewsPage(),
    LaunchesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: AppBottomNavigation(
              currentIndex: currentIndex,
              onTap: context.read<NavigationCubit>().setTab,
            ),
          );
        },
      ),
    );
  }
}
