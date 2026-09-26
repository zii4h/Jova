import 'package:flutter/material.dart';
import '../theme/field_log_theme.dart';

/// Dev note:
/// Shared collapse/expand shell. Used by the dashboard's per-stage groups
/// and the analytics "AI Insights" panel so both follow the same open/close
/// behavior instead of two one-off implementations.
///
/// The toggle-tappable zone is deliberately only the title/chevron area
/// (wrapped in its own GestureDetector), with [trailing] living as a
/// sibling in the header Row rather than a descendant of that zone — that
/// way a trailing action button (e.g. quick-add) never fights the header's
/// own tap-to-toggle for the same pointer event.
class CollapsibleSection extends StatefulWidget {
  final String title;
  final String? countLabel;
  final Color? accentColor;
  final Widget child;
  final bool initiallyExpanded;
  final Widget? trailing;

  final bool? expanded;

 const CollapsibleSection({
  super.key,
  required this.title,
  required this.child,
  this.countLabel,
  this.accentColor,
  this.initiallyExpanded = true,
  this.expanded,
  this.trailing,
});

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  late bool _expanded = widget.initiallyExpanded;

@override
void didUpdateWidget(covariant CollapsibleSection oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (widget.expanded != null &&
      widget.expanded != oldWidget.expanded) {
    _expanded = widget.expanded!;
  }
}

  @override
  Widget build(BuildContext context) {
    final tint = widget.accentColor ?? FieldLog.textPrimary;
    return Container(
      margin: const EdgeInsets.only(bottom: FieldLog.space12),
      decoration: BoxDecoration(
        color: FieldLog.surfaceCard,
        border: Border.all(color: FieldLog.border),
        borderRadius: BorderRadius.circular(FieldLog.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              widget.title.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: FieldLog.mono(size: 12, weight: FontWeight.w600),
                            ),
                          ),
                          if (widget.countLabel != null) ...[
                            const SizedBox(width: 6),
                            Text(widget.countLabel!,
                                style: FieldLog.mono(size: 11, color: FieldLog.textSecondary)),
                          ],
                          const SizedBox(width: 6),
                          AnimatedRotation(
                            turns: _expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: widget.child,
            ),
            secondChild: const SizedBox(width: double.infinity, height: 0),
            crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}
