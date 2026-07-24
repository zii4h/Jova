import 'package:flutter/material.dart';
import '../theme/field_log_theme.dart';

class FloatingDock extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const FloatingDock({super.key, required this.selectedIndex, required this.onSelect});

  static const _items = [
    (icon: Icons.list_alt_rounded, label: 'log'),
    (icon: Icons.calendar_month_rounded, label: 'calendar'),
    (icon: Icons.insights_rounded, label: 'analytics'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: FieldLog.textPrimary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (i) {
          final selected = i == selectedIndex;
          final item = _items[i];
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? FieldLog.bgPage : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                item.icon,
                size: 22,
                color: selected ? FieldLog.textPrimary : FieldLog.bgPage.withOpacity(0.65),
              ),
            ),
          );
        }),
      ),
    );
  }
}
