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
    final card = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(FieldLog.radiusCard),
      child: Container(
        margin: const EdgeInsets.only(bottom: FieldLog.space12),
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
        decoration: BoxDecoration(
          color: FieldLog.surfaceCard,
          border: Border.all(color: FieldLog.border),
          borderRadius: BorderRadius.circular(FieldLog.radiusCard),
          boxShadow: const [BoxShadow(color: Color(0x14000000), offset: Offset(1, 2))],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -22,
              right: 6,
              child: StatusStamp(status: application.status),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(application.company, style: FieldLog.display(size: 16)),
                const SizedBox(height: 2),
                Text(application.role, style: FieldLog.mono(size: 12)),
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
          ],
        ),
      ),
    );

    if (onDelete == null) return card;

    // Dev note:
    // Swipe-to-discard. confirmDismiss gates it behind a dialog since this
    // is destructive and there's no undo yet — no snackbar-with-undo to
    // wire up until state is backed by something more durable than the
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
