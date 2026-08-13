import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/navigation/presentation/cubit/navigation_cubit.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/no_internet_widget.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/apod_card.dart';
import '../widgets/home_error_view.dart';
import '../widgets/home_loading_skeleton.dart';
import '../widgets/latest_launches_section.dart';
import '../widgets/latest_news_section.dart';
import '../widgets/observatories_section.dart';
import '../widgets/solar_system_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return BlocListener<LocaleCubit, Locale>(
      listener: (context, _) {
        context.read<HomeCubit>().load();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(t.homeTitle)),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return switch (state) {
              HomeInitial() => const SizedBox.shrink(),
              HomeLoading() => const HomeLoadingSkeleton(),
              HomeError(isNoInternet: true) => NoInternetWidget(
                  onRetry: () => context.read<HomeCubit>().load(),
                ),
              HomeError() => HomeErrorView(
                  onRetry: () => context.read<HomeCubit>().load(),
                ),
              HomeLoaded() => _HomeContent(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().load(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (state.apod != null) ...[
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.apodDetail,
                  arguments: state.apod,
                ),
                child: ApodCard(apod: state.apod!),
              ),
              const SizedBox(height: 32),
            ],
            const SolarSystemSection(),
            const SizedBox(height: 24),
            LatestNewsSection(
              articles: state.latestNews,
              onSeeAll: () {
                context.read<NavigationCubit>().setTab(1);
              },
              onArticleTap: (article) {
                context.read<NavigationCubit>().setTab(1);
                Navigator.of(context).pushNamed(
                  AppRoutes.newsDetail,
                  arguments: article,
                );
              },
            ),
            if (state.observatories.isNotEmpty) ...[
              const SizedBox(height: 32),
              ObservatoriesSection(observatories: state.observatories),
            ],
            const SizedBox(height: 32),
            LatestLaunchesSection(
              launches: state.latestLaunches,
              onSeeAll: () => Navigator.of(context).pushNamed(
                AppRoutes.launches,
              ),
              onLaunchTap: (launch) {
                Navigator.of(context).pushNamed(AppRoutes.launches);
                Navigator.of(context).pushNamed(
                  AppRoutes.launchDetail,
                  arguments: launch,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
