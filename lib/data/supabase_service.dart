import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/application.dart';

class StageConfig {
  final ApplicationStatus status;
  final String displayName;
  final int position;

  const StageConfig({
    required this.status,
    required this.displayName,
    required this.position,
  });
}

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _userId {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('No authenticated user.');
    }

    return user.id;
  }

  // ------------------------------------------------------------
  // Applications
  // ------------------------------------------------------------

  Future<List<JobApplication>> getApplications() async {
    final rows = await _client
        .from('applications')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false);

    return rows.map<JobApplication>((row) {
      return JobApplication(
        id: row['id'].toString(),
        company: row['company'] ?? '',
        role: row['role'] ?? '',
        appliedDate: DateTime.parse(row['applied_date']),
        status: _statusFromString(row['status']),
        source: row['source'] ?? '',
        notes: row['notes'] ?? '',
        location: row['location'] ?? '',
        jobType: row['job_type'] ?? '',
        salary: row['salary'] ?? '',
        description: row['description'] ?? '',
        recruiterName: row['recruiter_name'] ?? '',
        recruiterEmail: row['recruiter_email'] ?? '',
        recruiterLinkedIn: row['recruiter_linkedin'] ?? '',
        lastContacted: row['last_contacted'] == null
            ? null
            : DateTime.parse(row['last_contacted']),
      );
    }).toList();
  }

  Future<void> addApplication(JobApplication app) async {
    await _client.from('applications').insert({
      ..._toDatabase(app),
      'user_id': _userId,
    });
  }

  Future<void> updateApplication(JobApplication app) async {
    await _client
        .from('applications')
        .update(_toDatabase(app))
        .eq('id', app.id)
        .eq('user_id', _userId);
  }

  Future<void> deleteApplication(String id) async {
    await _client
        .from('applications')
        .delete()
        .eq('id', id)
        .eq('user_id', _userId);
  }

  // ------------------------------------------------------------
  // Stages
  // ------------------------------------------------------------

  Future<List<StageConfig>> getStages() async {
    var rows = await _client
        .from('stages')
        .select()
        .eq('user_id', _userId)
        .order('position', ascending: true);

    // A new Google account has no stage rows yet.
    // Create Jova's five defaults on first use.
    if (rows.isEmpty) {
      await _createDefaultStages();

      rows = await _client
          .from('stages')
          .select()
          .eq('user_id', _userId)
          .order('position', ascending: true);
    }

    return rows.map<StageConfig>((row) {
      return StageConfig(
        status: _statusFromString(row['status_key']),
        displayName: row['display_name'] ?? '',
        position: row['position'] ?? 0,
      );
    }).toList();
  }

  Future<void> _createDefaultStages() async {
    final userId = _userId;

    final defaults = <Map<String, dynamic>>[
      {
        'user_id': userId,
        'status_key': ApplicationStatus.applied.name,
        'display_name': ApplicationStatus.applied.label,
        'position': 0,
      },
      {
        'user_id': userId,
        'status_key': ApplicationStatus.screening.name,
        'display_name': ApplicationStatus.screening.label,
        'position': 1,
      },
      {
        'user_id': userId,
        'status_key': ApplicationStatus.interview.name,
        'display_name': ApplicationStatus.interview.label,
        'position': 2,
      },
      {
        'user_id': userId,
        'status_key': ApplicationStatus.offer.name,
        'display_name': ApplicationStatus.offer.label,
        'position': 3,
      },
      {
        'user_id': userId,
        'status_key': ApplicationStatus.rejected.name,
        'display_name': ApplicationStatus.rejected.label,
        'position': 4,
      },
    ];

    await _client.from('stages').upsert(
          defaults,
          onConflict: 'user_id,status_key',
          ignoreDuplicates: true,
        );
  }

  Future<void> updateStages(
    List<ApplicationStatus> order,
    Map<ApplicationStatus, String> labels,
  ) async {
    final userId = _userId;

    await Future.wait(
      List.generate(order.length, (index) {
        final status = order[index];

        return _client
            .from('stages')
            .update({
              'display_name': labels[status] ?? status.label,
              'position': index,
            })
            .eq('user_id', userId)
            .eq('status_key', status.name);
      }),
    );
  }

  // ------------------------------------------------------------
  // Mapping
  // ------------------------------------------------------------

  Map<String, dynamic> _toDatabase(JobApplication app) {
    return {
      'id': app.id,
      'company': app.company,
      'role': app.role,
      'applied_date': _dateOnly(app.appliedDate),
      'status': app.status.name,
      'source': app.source,
      'notes': app.notes,
      'location': app.location,
      'job_type': app.jobType,
      'salary': app.salary,
      'description': app.description,
      'recruiter_name': app.recruiterName,
      'recruiter_email': app.recruiterEmail,
      'recruiter_linkedin': app.recruiterLinkedIn,
      'last_contacted':
          app.lastContacted == null ? null : _dateOnly(app.lastContacted!),
    };
  }

  String _dateOnly(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  ApplicationStatus _statusFromString(dynamic value) {
    final status = value?.toString();

    return ApplicationStatus.values.firstWhere(
      (item) => item.name == status,
      orElse: () => ApplicationStatus.applied,
    );
  }
}