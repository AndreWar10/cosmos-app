import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/launch.dart';
import 'launch_status_badge.dart';

class LaunchCard extends StatelessWidget {
  const LaunchCard({
    super.key,
    required this.launch,
    this.onTap,
  });

  final Launch launch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _PatchThumbnail(imageUrl: launch.links.patchSmall),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                launch.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                launch.rocket,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: secondaryColor,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 12, color: secondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(launch.dateUtc),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: secondaryColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LaunchStatusBadge(
                success: launch.success,
                upcoming: launch.upcoming,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _PatchThumbnail extends StatelessWidget {
  const _PatchThumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.rocket_launch,
          color: AppColors.primary,
          size: 36,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          color: AppColors.primary.withValues(alpha: 0.05),
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (_, _, _) => Container(
          color: AppColors.primary.withValues(alpha: 0.08),
          child: const Icon(
            Icons.rocket_launch,
            color: AppColors.primary,
            size: 36,
          ),
        ),
      ),
    );
  }
}
