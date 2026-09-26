import 'package:flutter/material.dart';
import '../theme/field_log_theme.dart';

enum ApplicationStatus {
  applied,
  screening,
  interview,
  offer,
  rejected,
}

/// The actual progression stages used by the conversion funnel.
///
/// Rejected is intentionally excluded because rejection is an outcome,
/// not a progression stage.
enum ApplicationStage {
  applied,
  screening,
  interview,
  offer,
}

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

extension ApplicationStageX on ApplicationStage {
  String get label {
    switch (this) {
      case ApplicationStage.applied:
        return 'APPLIED';
      case ApplicationStage.screening:
        return 'SCREENING';
      case ApplicationStage.interview:
        return 'INTERVIEW';
      case ApplicationStage.offer:
        return 'OFFER';
    }
  }

  int get rank {
    switch (this) {
      case ApplicationStage.applied:
        return 0;
      case ApplicationStage.screening:
        return 1;
      case ApplicationStage.interview:
        return 2;
      case ApplicationStage.offer:
        return 3;
    }
  }
}

class JobApplication {
  final String id;

  String company;
  String role;
  DateTime appliedDate;
  ApplicationStatus status;

  /// Furthest progression stage this application has ever reached.
  ///
  /// This is preserved even if the application is later rejected
  /// or moved back to an earlier status.
  ApplicationStage highestStageReached;

  String source;
  String notes;

  // Dev note:
  // Added for the Details/Recruiter split in the edit form. All optional
  // (default ''/null) so existing callers and mock data don't break.
  String location;
  String jobType;
  String salary;
  String description;
  String recruiterName;
  String recruiterEmail;
  String recruiterLinkedIn;
  DateTime? lastContacted;

  JobApplication({
    required this.id,
    required this.company,
    required this.role,
    required this.appliedDate,
    required this.status,
    ApplicationStage? highestStageReached,
    this.source = '',
    this.notes = '',
    this.location = '',
    this.jobType = '',
    this.salary = '',
    this.description = '',
    this.recruiterName = '',
    this.recruiterEmail = '',
    this.recruiterLinkedIn = '',
    this.lastContacted,
  }) : highestStageReached =
            highestStageReached ?? stageFromStatus(status);

  JobApplication copyWith({
    String? company,
    String? role,
    DateTime? appliedDate,
    ApplicationStatus? status,
    ApplicationStage? highestStageReached,
    String? source,
    String? notes,
    String? location,
    String? jobType,
    String? salary,
    String? description,
    String? recruiterName,
    String? recruiterEmail,
    String? recruiterLinkedIn,
    DateTime? lastContacted,
  }) {
    final newStatus = status ?? this.status;

    final requestedStage =
        highestStageReached ?? stageFromStatus(newStatus);

    final preservedHighestStage =
        requestedStage.rank > this.highestStageReached.rank
            ? requestedStage
            : this.highestStageReached;

    return JobApplication(
      id: id,
      company: company ?? this.company,
      role: role ?? this.role,
      appliedDate: appliedDate ?? this.appliedDate,
      status: newStatus,
      highestStageReached: preservedHighestStage,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      jobType: jobType ?? this.jobType,
      salary: salary ?? this.salary,
      description: description ?? this.description,
      recruiterName: recruiterName ?? this.recruiterName,
      recruiterEmail: recruiterEmail ?? this.recruiterEmail,
      recruiterLinkedIn:
          recruiterLinkedIn ?? this.recruiterLinkedIn,
      lastContacted: lastContacted ?? this.lastContacted,
    );
  }

  static ApplicationStage stageFromStatus(
    ApplicationStatus status,
  ) {
    switch (status) {
      case ApplicationStatus.applied:
        return ApplicationStage.applied;

      case ApplicationStatus.screening:
        return ApplicationStage.screening;

      case ApplicationStatus.interview:
        return ApplicationStage.interview;

      case ApplicationStatus.offer:
        return ApplicationStage.offer;

      case ApplicationStatus.rejected:
        // Rejected itself does not tell us which progression stage
        // the application reached.
        return ApplicationStage.applied;
    }
  }
}