import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class LaunchStatusBadge extends StatelessWidget {
  const LaunchStatusBadge({
    super.key,
    required this.success,
    required this.upcoming,
  });

  final bool? success;
  final bool upcoming;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final (label, color) = _resolve(t);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  (String, Color) _resolve(dynamic t) {
    if (upcoming) return (t.launchDetailStatusUpcoming, AppColors.primary);
    if (success == true) {
      return (t.launchDetailStatusSuccess, AppColors.secondary);
    }
    return (t.launchDetailStatusFailed, AppColors.accent);
  }
}
