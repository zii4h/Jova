import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';

class StatusStamp extends StatelessWidget {
  final ApplicationStatus status;
  final double rotationDeg;

  const StatusStamp({super.key, required this.status, this.rotationDeg = -6});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationDeg * 3.1415926535 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: FieldLog.surfaceCard,
          border: Border.all(color: status.color, width: 1.5),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          status.label,
          style: FieldLog.mono(size: 10, color: status.color, weight: FontWeight.w600),
        ),
      ),
    );
  }
}
