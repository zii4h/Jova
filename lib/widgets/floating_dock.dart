import 'package:flutter/material.dart';

import '../theme/field_log_theme.dart';

class FloatingDock extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const FloatingDock({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 48,
        vertical: 18,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: FieldLog.textPrimary,
        borderRadius: BorderRadius.circular(
          FieldLog.radiusCard,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DockItem(
            icon: Icons.view_agenda_outlined,
            selectedIcon: Icons.view_agenda_rounded,
            selected: selectedIndex == 0,
            tooltip: 'Applications',
            onTap: () => onSelect(0),
          ),
          _DockItem(
            icon: Icons.calendar_today_outlined,
            selectedIcon: Icons.calendar_today_rounded,
            selected: selectedIndex == 1,
            tooltip: 'Calendar',
            onTap: () => onSelect(1),
          ),
          _DockItem(
            icon: Icons.bar_chart_outlined,
            selectedIcon: Icons.bar_chart_rounded,
            selected: selectedIndex == 2,
            tooltip: 'Analytics',
            onTap: () => onSelect(2),
          ),
        ],
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final String tooltip;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected
        ? FieldLog.surfaceCard
        : Colors.transparent;

    final foregroundColor = selected
        ? FieldLog.textPrimary
        : FieldLog.textTertiary;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          FieldLog.radiusControl,
        ),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 150,
          ),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              FieldLog.radiusControl,
            ),
          ),
          child: Icon(
            selected ? selectedIcon : icon,
            size: 20,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}