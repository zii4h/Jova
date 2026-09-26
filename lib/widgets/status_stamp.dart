// status_stamp.dart

import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';

class StatusStamp extends StatelessWidget {
  final ApplicationStatus status;

  const StatusStamp({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        status.label,
        style: FieldLog.body(
          size: 10,
          color: Colors.white,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}