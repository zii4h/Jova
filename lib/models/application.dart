import 'package:flutter/material.dart';
import '../theme/field_log_theme.dart';

enum ApplicationStatus { applied, screening, interview, offer, rejected }

extension ApplicationStatusX on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'APPLIED';
      case ApplicationStatus.screening:
        return 'SCREENING';
      case ApplicationStatus.interview:
        return 'INTERVIEW';
      case ApplicationStatus.offer:
        return 'OFFER';
      case ApplicationStatus.rejected:
        return 'REJECTED';
    }
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.applied:
        return FieldLog.stageApplied;
      case ApplicationStatus.screening:
        return FieldLog.stageScreening;
      case ApplicationStatus.interview:
        return FieldLog.stageInterview;
      case ApplicationStatus.offer:
        return FieldLog.stageOffer;
      case ApplicationStatus.rejected:
        return FieldLog.stageRejected;
    }
  }
}

class JobApplication {
  final String id;
  String company;
  String role;
  DateTime appliedDate;
  ApplicationStatus status;
  String source;
  String notes;

  JobApplication({
    required this.id,
    required this.company,
    required this.role,
    required this.appliedDate,
    required this.status,
    this.source = '',
    this.notes = '',
  });

  JobApplication copyWith({
    String? company,
    String? role,
    DateTime? appliedDate,
    ApplicationStatus? status,
    String? source,
    String? notes,
  }) {
    return JobApplication(
      id: id,
      company: company ?? this.company,
      role: role ?? this.role,
      appliedDate: appliedDate ?? this.appliedDate,
      status: status ?? this.status,
      source: source ?? this.source,
      notes: notes ?? this.notes,
    );
  }
}
