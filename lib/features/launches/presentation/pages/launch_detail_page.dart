import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/launch.dart';
import '../widgets/launch_detail_widgets.dart';
import '../widgets/launch_status_badge.dart';

class LaunchDetailPage extends StatelessWidget {
  const LaunchDetailPage({super.key, required this.launch});

  final Launch launch;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(title: Text(launch.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LaunchPatchHeader(launch: launch),
            const SizedBox(height: 24),
            LaunchInfoRow(
              label: t.launchDetailRocket,
              value: launch.rocket,
              icon: Icons.rocket_launch,
            ),
            LaunchInfoRow(
              label: t.launchDetailLaunchpad,
              value: launch.launchpad,
              icon: Icons.location_on_outlined,
            ),
            LaunchInfoRow(
              label: t.launchDetailDate,
              value: _formatDate(launch.dateUtc),
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: secondaryColor),
                const SizedBox(width: 8),
                Text(t.launchDetailStatus, style: theme.textTheme.bodyMedium),
                const SizedBox(width: 8),
                LaunchStatusBadge(
                  success: launch.success,
                  upcoming: launch.upcoming,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: theme.dividerColor),
            const SizedBox(height: 12),
            Text(
              launch.details ?? t.launchDetailNoDetails,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: launch.details != null ? null : secondaryColor,
                fontStyle:
                    launch.details != null ? null : FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            LaunchLinksSection(launch: launch),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} UTC';
  }
}
