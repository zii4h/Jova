import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';
import 'status_stamp.dart';

class IndexCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const IndexCard({super.key, required this.application, this.onTap, this.onDelete});

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    // Dev note:
    // Preview row only shows fields the user actually set (per-field, not
    // all-or-nothing) — an application logged with just company/role still
    // renders a clean card instead of empty icon rows.
    final previewChips = <Widget>[
      if (application.location.trim().isNotEmpty)
        _PreviewChip(icon: Icons.place_outlined, label: application.location.trim()),
      if (application.jobType.trim().isNotEmpty)
        _PreviewChip(icon: Icons.work_outline_rounded, label: application.jobType.trim()),
      if (application.salary.trim().isNotEmpty)
        _PreviewChip(icon: Icons.payments_outlined, label: application.salary.trim()),
    ];

    final card = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(FieldLog.radiusCard),
      child: Container(
        margin: const EdgeInsets.only(bottom: FieldLog.space12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: FieldLog.surfaceCard,
          border: Border.all(color: FieldLog.border),
          borderRadius: BorderRadius.circular(FieldLog.radiusCard),
          boxShadow: const [BoxShadow(color: Color(0x14000000), offset: Offset(1, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(application.company, style: FieldLog.display(size: 16)),
                      const SizedBox(height: 2),
                      Text(application.role, style: FieldLog.mono(size: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusStamp(status: application.status),
              ],
            ),
            if (previewChips.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(spacing: 12, runSpacing: 6, children: previewChips),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('applied ${_formatDate(application.appliedDate)}',
                    style: FieldLog.mono(size: 11, color: FieldLog.textSecondary)),
                if (application.source.isNotEmpty)
                  Text(application.source,
                      style: FieldLog.mono(size: 11, color: FieldLog.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );

    if (onDelete == null) return card;

    // Dev note:
    // Swipe-to-discard, gated behind a confirm dialog since it's
    // destructive and there's no undo yet — no snackbar-with-undo to wire
    // up until state is backed by something more durable than the
    // in-memory list.
    return Dismissible(
      key: ValueKey(application.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete!.call(),
      background: const SizedBox.shrink(),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: FieldLog.space12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: FieldLog.stageRejected,
          borderRadius: BorderRadius.circular(FieldLog.radiusCard),
        ),
        child: Text('discard', style: FieldLog.mono(size: 12, color: FieldLog.bgPage, weight: FontWeight.w600)),
      ),
      child: card,
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FieldLog.surfaceCard,
        title: Text('discard entry?', style: FieldLog.display(size: 16)),
        content: Text('this removes ${application.company} from the log for good.',
            style: FieldLog.body(size: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('keep', style: FieldLog.mono(size: 12)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('discard', style: FieldLog.mono(size: 12, color: FieldLog.stageRejected)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _PreviewChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PreviewChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: FieldLog.textSecondary),
        const SizedBox(width: 3),
        Text(label, style: FieldLog.mono(size: 11, color: FieldLog.textSecondary)),
      ],
    );
  }
}
