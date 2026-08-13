import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/navigation/presentation/cubit/navigation_cubit.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/apod_card.dart';
import '../widgets/latest_launches_section.dart';
import '../widgets/latest_news_section.dart';
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
              HomeLoading() => const _HomeLoadingSkeleton(),
              HomeError() => _HomeErrorView(
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
              const SizedBox(height: 24),
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
            const SizedBox(height: 24),
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

class _HomeLoadingSkeleton extends StatelessWidget {
  const _HomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final divider = Theme.of(context).dividerColor;
    final surface = Theme.of(context).colorScheme.surface;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // APOD
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 240,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 24),
          // Solar System
          _SkeletonTitle(width: 120, color: divider),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (_, _) => Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: divider,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 10,
                    decoration: BoxDecoration(
                      color: divider,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Latest News
          _SkeletonTitle(width: 140, color: divider),
          const SizedBox(height: 12),
          _SkeletonCarousel(
            height: 180,
            cardWidth: 200,
            cardCount: 3,
            surface: surface,
            divider: divider,
          ),
          const SizedBox(height: 24),
          // Upcoming Launches
          _SkeletonTitle(width: 160, color: divider),
          const SizedBox(height: 12),
          _SkeletonCarousel(
            height: 180,
            cardWidth: 200,
            cardCount: 3,
            surface: surface,
            divider: divider,
          ),
        ],
      ),
    );
  }
}

class _SkeletonTitle extends StatelessWidget {
  const _SkeletonTitle({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 14,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}

class _SkeletonCarousel extends StatelessWidget {
  const _SkeletonCarousel({
    required this.height,
    required this.cardWidth,
    required this.cardCount,
    required this.surface,
    required this.divider,
  });

  final double height;
  final double cardWidth;
  final int cardCount;
  final Color surface;
  final Color divider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cardCount,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => SizedBox(
          width: cardWidth,
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(color: divider.withValues(alpha: 0.3)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: cardWidth * 0.7,
                        decoration: BoxDecoration(
                          color: divider,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: cardWidth * 0.45,
                        decoration: BoxDecoration(
                          color: divider.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(context.translate.newsErrorRetry),
          ),
        ],
      ),
    );
  }
}
