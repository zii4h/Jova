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
          final item = _items[i];
          return _DockItem(
            icon: item.icon,
            selected: i == selectedIndex,
            onTap: () => onSelect(i),
          );
        }),
      ),
    );
  }
}

/// Dev note:
/// Split out from a stateless `GestureDetector` so each icon can track its
/// own hover state independently — a shared MouseRegion on the whole dock
/// couldn't tell which icon the pointer is actually over.
class _DockItem extends StatefulWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DockItem({required this.icon, required this.selected, required this.onTap});

  @override
  State<_DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<_DockItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.selected
        ? FieldLog.bgPage
        : (_hovering ? FieldLog.bgPage.withOpacity(0.18) : Colors.transparent);
    final iconColor = widget.selected ? FieldLog.textPrimary : FieldLog.bgPage.withOpacity(0.65);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(widget.icon, size: 22, color: iconColor),
        ),
      ),
    );
  }
}
