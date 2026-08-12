import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class LaunchFilterBar extends StatelessWidget {
  const LaunchFilterBar({
    super.key,
    required this.upcomingFilter,
    required this.onUpcomingChanged,
  });

  final bool? upcomingFilter;
  final ValueChanged<bool?> onUpcomingChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _FilterPill(
              icon: Icons.schedule_rounded,
              label: t.launchesUpcoming,
              selected: upcomingFilter == true,
              onTap: () => onUpcomingChanged(true),
            ),
            const SizedBox(width: 8),
            _FilterPill(
              icon: Icons.history_rounded,
              label: t.launchesPast,
              selected: upcomingFilter == false,
              onTap: () => onUpcomingChanged(false),
            ),
            const SizedBox(width: 8),
            _FilterPill(
              icon: Icons.all_inclusive_rounded,
              label: t.launchesAll,
              selected: upcomingFilter == null,
              onTap: () => onUpcomingChanged(null),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const activeColor = AppColors.primary;

    final bg = selected
        ? activeColor.withValues(alpha: 0.15)
        : isDark
            ? AppColors.darkSurface
            : AppColors.lightSurfaceLight;

    final border = selected
        ? activeColor.withValues(alpha: 0.4)
        : isDark
            ? AppColors.darkDivider
            : AppColors.lightDivider;

    final fg = selected
        ? activeColor
        : isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
