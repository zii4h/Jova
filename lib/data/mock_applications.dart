import '../models/application.dart';

/// Seed data so the app isn't empty on first run.
/// Swap this out once Supabase is wired in (see the Proposal, 1.9).
List<JobApplication> buildMockApplications() {
  final now = DateTime.now();
  DateTime daysAgo(int d) => DateTime(now.year, now.month, now.day).subtract(Duration(days: d));

  return [
    JobApplication(
      id: '1',
      company: 'Northwind Labs',
      role: 'Frontend Developer Intern',
      appliedDate: daysAgo(21),
      status: ApplicationStatus.interview,
      source: 'Referral',
    ),
    JobApplication(
      id: '2',
      company: 'Vantra Systems',
      role: 'Junior Full Stack Dev',
      appliedDate: daysAgo(14),
      status: ApplicationStatus.screening,
      source: 'Job board',
    ),
    JobApplication(
      id: '3',
      company: 'Corebase Inc.',
      role: 'Backend OJT',
      appliedDate: daysAgo(26),
      status: ApplicationStatus.rejected,
      source: 'Company site',
    ),
    JobApplication(
      id: '4',
      company: 'Studio Palet',
      role: 'UI Engineer Intern',
      appliedDate: daysAgo(7),
      status: ApplicationStatus.applied,
      source: 'Job board',
    ),
    JobApplication(
      id: '5',
      company: 'Haven Analytics',
      role: 'Data/Backend Intern',
      appliedDate: daysAgo(4),
      status: ApplicationStatus.applied,
      source: 'Referral',
    ),
    JobApplication(
      id: '6',
      company: 'Loop & Co.',
      role: 'Mobile Developer Intern',
      appliedDate: daysAgo(30),
      status: ApplicationStatus.offer,
      source: 'Career fair',
    ),
  ];
}
