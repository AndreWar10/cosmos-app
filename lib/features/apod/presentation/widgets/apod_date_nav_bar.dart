import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ApodDateNavBar extends StatelessWidget {
  const ApodDateNavBar({
    super.key,
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
