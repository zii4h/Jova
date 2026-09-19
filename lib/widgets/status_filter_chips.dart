import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';

/// Dev note:
/// Horizontal row of stage filter chips for the dashboard. `null` in
/// [selected] means "all stages". Kept separate from StatusStamp since
/// this reads as a tab control, not a per-entry stamp. Radius matches
/// FieldLog.radiusControl (not a maxed-out pill) to stay consistent with
/// the cards' minimal squareness.
class StatusFilterChips extends StatelessWidget {
  final ApplicationStatus? selected;
  final ValueChanged<ApplicationStatus?> onSelect;
  final Map<ApplicationStatus, int> counts;

  const StatusFilterChips({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold(0, (a, b) => a + b);
    final chips = <Widget>[
      _Chip(label: 'all', count: total, active: selected == null, onTap: () => onSelect(null)),
      for (final status in ApplicationStatus.values)
        _Chip(
          label: status.label.toLowerCase(),
          count: counts[status] ?? 0,
          active: selected == status,
          color: status.color,
          onTap: () => onSelect(status),
        ),
    ];

    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => chips[i],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;
  final Color? color;

  const _Chip({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tint = color ?? FieldLog.textPrimary;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FieldLog.radiusControl),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active ? tint : Colors.transparent,
            border: Border.all(color: tint),
            borderRadius: BorderRadius.circular(FieldLog.radiusControl),
          ),
          alignment: Alignment.center,
          child: Text(
            '$label · $count',
            style: FieldLog.mono(size: 11, color: active ? FieldLog.bgPage : tint, weight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
