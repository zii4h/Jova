import 'package:flutter/material.dart';

import '../models/application.dart';
import '../theme/field_log_theme.dart';

class StatusFilterChips extends StatelessWidget {
  final ApplicationStatus? selected;
  final Map<ApplicationStatus, int> counts;
  final List<ApplicationStatus> order;
  final Map<ApplicationStatus, String> labels;
  final ValueChanged<ApplicationStatus?> onSelect;

  const StatusFilterChips({
    super.key,
    required this.selected,
    required this.counts,
    required this.order,
    required this.labels,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'All',
            count: counts.values.fold(0, (sum, count) => sum + count),
            active: selected == null,
            color: FieldLog.textPrimary,
            onTap: () => onSelect(null),
          ),

          const SizedBox(width: 7),

          for (int i = 0; i < order.length; i++) ...[
            _FilterChip(
              label: labels[order[i]] ?? order[i].label,
              count: counts[order[i]] ?? 0,
              active: selected == order[i],
              color: order[i].color,
              onTap: () => onSelect(order[i]),
            ),
            if (i != order.length - 1) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.fromLTRB(
            12, // left
            9, // top
            12, // right
            8, // bottom
          ),
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(FieldLog.radiusControl),
            border: Border.all(color: active ? color : FieldLog.borderStrong),
          ),
          child: Text(
            '$label · $count',
            style: FieldLog.body(
              size: 11,
              color: active ? Colors.white : FieldLog.textSecondary,
              weight: active ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
