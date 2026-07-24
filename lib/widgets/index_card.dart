import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';
import 'status_stamp.dart';

class IndexCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onTap;

  const IndexCard({super.key, required this.application, this.onTap});

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
  }
}
