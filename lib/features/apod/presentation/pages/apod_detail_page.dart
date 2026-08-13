import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/apod.dart';
import '../cubit/apod_detail_cubit.dart';

class ApodDetailPage extends StatelessWidget {
  const ApodDetailPage({super.key, required this.apod});

  final Apod apod;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ApodDetailCubit>()..init(apod),
      child: const _ApodDetailView(),
    );
  }
}

class _ApodDetailView extends StatelessWidget {
  const _ApodDetailView();

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(title: Text(t.homeApod)),
      body: BlocBuilder<ApodDetailCubit, ApodDetailState>(
        builder: (context, state) {
          final apod = state.apod;
          final cubit = context.read<ApodDetailCubit>();

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DateNavBar(
                      date: state.currentDate,
                      canGoForward: state.canGoForward,
                      onPrevious: cubit.goToPreviousDay,
                      onNext: cubit.goToNextDay,
                    ),
                    if (apod.isImage)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: apod.hdUrl ?? apod.url,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (_, _, _) => Container(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined,
                                  size: 48),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apod.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: secondaryColor),
                              const SizedBox(width: 6),
                              Text(
                                apod.date,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: secondaryColor,
                                ),
                              ),
                              if (apod.copyright != null) ...[
                                const SizedBox(width: 16),
                                Icon(Icons.copyright,
                                    size: 16, color: secondaryColor),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    apod.copyright!,
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(
                                      color: secondaryColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(color: theme.dividerColor),
                          const SizedBox(height: 16),
                          Text(
                            apod.explanation,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isLoading)
                Container(
                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.7),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _DateNavBar extends StatelessWidget {
  const _DateNavBar({
    required this.date,
    required this.canGoForward,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime date;
  final bool canGoForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isDark
          ? AppColors.darkSurface
          : AppColors.lightSurfaceLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left_rounded, size: 28),
            tooltip: 'Previous day',
          ),
          Text(
            _formatDate(date),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: canGoForward ? onNext : null,
            icon: const Icon(Icons.chevron_right_rounded, size: 28),
            tooltip: 'Next day',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}
