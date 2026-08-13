import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../launches/domain/entities/launch.dart';
import '../../../launches/presentation/widgets/launch_status_badge.dart';

class LatestLaunchesSection extends StatelessWidget {
  const LatestLaunchesSection({
    super.key,
    required this.launches,
    this.onSeeAll,
    this.onLaunchTap,
  });

  final List<Launch> launches;
  final VoidCallback? onSeeAll;
  final ValueChanged<Launch>? onLaunchTap;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);

    if (launches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.homeLatestLaunches,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Row(
                  children: [
                    Text(
                      t.homeSeeAll,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: launches.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => GestureDetector(
                onTap: () => onLaunchTap?.call(launches[index]),
                child: _LaunchPreviewCard(launch: launches[index]),
              ),
          ),
        ),
      ],
    );
  }
}

class _LaunchPreviewCard extends StatelessWidget {
  const _LaunchPreviewCard({required this.launch});

  final Launch launch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: 220,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: launch.links.patchSmall != null
                    ? CachedNetworkImage(
                        imageUrl: launch.links.patchSmall!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: AppColors.primary.withValues(alpha: 0.05),
                        ),
                        errorWidget: (_, _, _) => _PlaceholderIcon(),
                      )
                    : _PlaceholderIcon(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    launch.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(launch.dateUtc),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: secondaryColor,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LaunchStatusBadge(
                    success: launch.success,
                    upcoming: launch.upcoming,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _PlaceholderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: const Center(
        child: Icon(
          Icons.rocket_launch_outlined,
          color: AppColors.primary,
          size: 32,
        ),
      ),
    );
  }
}
