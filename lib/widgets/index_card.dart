import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';
import 'status_stamp.dart';

class IndexCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const IndexCard({
    super.key,
    required this.application,
    this.onTap,
    this.onDelete,
  });

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final previewChips = <Widget>[
      if (application.location.trim().isNotEmpty)
        _PreviewChip(
          icon: Icons.place_outlined,
          label: application.location.trim(),
        ),
      if (application.jobType.trim().isNotEmpty)
        _PreviewChip(
          icon: Icons.work_outline_rounded,
          label: application.jobType.trim(),
        ),
      if (application.salary.trim().isNotEmpty)
        _PreviewChip(
          icon: Icons.payments_outlined,
          label: application.salary.trim(),
        ),
    ];

    final card = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(FieldLog.radiusCard),
          child: Ink(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // Slightly darker than the page/card surface so individual
              // applications remain visible when stacked.
              color: const Color(0xFFF1F2F4).withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(FieldLog.radiusCard),

              // Very subtle edge instead of the old full card outline.
              border: Border.all(
                color: FieldLog.border.withValues(alpha: 0.65),
              ),
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
                          Text(
                            application.company,
                            style: FieldLog.display(
                              size: 16,
                              weight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            application.role,
                            style: FieldLog.body(
                              size: 12,
                              color: FieldLog.textSecondary,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusStamp(status: application.status),
                  ],
                ),

                if (previewChips.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(spacing: 14, runSpacing: 7, children: previewChips),
                ],

                const SizedBox(height: 13),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Applied ${_formatDate(application.appliedDate)}',
                      style: FieldLog.body(
                        size: 11,
                        color: FieldLog.textSecondary,
                        weight: FontWeight.w400,
                      ),
                    ),
                    if (application.source.trim().isNotEmpty)
                      Flexible(
                        child: Text(
                          application.source.trim(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: FieldLog.body(
                            size: 11,
                            color: FieldLog.textSecondary,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (onDelete == null) {
      return card;
    }

    return Dismissible(
      key: ValueKey(application.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete!.call(),
      background: const SizedBox.shrink(),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: FieldLog.stageRejected,
          borderRadius: BorderRadius.circular(FieldLog.radiusCard),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      child: card,
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FieldLog.surfaceCard,
        title: Text(
          'Discard entry?',
          style: FieldLog.display(size: 16, weight: FontWeight.w600),
        ),
        content: Text(
          'This removes ${application.company} from the log for good.',
          style: FieldLog.body(size: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Keep',
              style: FieldLog.body(size: 12, weight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Discard',
              style: FieldLog.body(
                size: 12,
                color: FieldLog.stageRejected,
                weight: FontWeight.w600,
              ),
            ),
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
        const SizedBox(width: 4),
        Text(
          label,
          style: FieldLog.body(size: 11, color: FieldLog.textSecondary),
        ),
      ],
    );
  }
}
