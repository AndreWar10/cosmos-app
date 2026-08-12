import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';

class LaunchFilterBar extends StatelessWidget {
  const LaunchFilterBar({
    super.key,
    required this.upcomingFilter,
    required this.statusFilter,
    required this.onUpcomingChanged,
    required this.onStatusChanged,
  });

  final bool? upcomingFilter;
  final String? statusFilter;
  final ValueChanged<bool?> onUpcomingChanged;
  final ValueChanged<String?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          SegmentedButton<bool?>(
            segments: [
              ButtonSegment(value: true, label: Text(t.launchesUpcoming)),
              ButtonSegment(value: false, label: Text(t.launchesPast)),
              ButtonSegment(value: null, label: Text(t.launchesAll)),
            ],
            selected: {upcomingFilter},
            onSelectionChanged: (s) => onUpcomingChanged(s.first),
            showSelectedIcon: false,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StatusChip(
                  label: t.launchesAll,
                  selected: statusFilter == null,
                  onTap: () => onStatusChanged(null),
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  label: t.launchesFilterSuccess,
                  selected: statusFilter == 'success',
                  onTap: () => onStatusChanged('success'),
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  label: t.launchesFilterFailed,
                  selected: statusFilter == 'failure',
                  onTap: () => onStatusChanged('failure'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    );
  }
}
