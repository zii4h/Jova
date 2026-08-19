import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';

/// Dev note:
/// Small inline status tag shown on each card. Previously a rotated
/// "rubber stamp" floating outside the card's bounds — simplified to a
/// flat tag that sits inside the card's own layout, matching the
/// wireframe and the squared, minimal-radius language used everywhere
/// else now (filter chips, buttons, inputs).
class StatusStamp extends StatelessWidget {
  final ApplicationStatus status;

  const StatusStamp({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        border: Border.all(color: status.color, width: 1),
        borderRadius: BorderRadius.circular(FieldLog.radiusControl),
      ),
      child: Text(
        status.label,
        style: FieldLog.mono(size: 10, color: status.color, weight: FontWeight.w600),
      ),
    );
  }
}
