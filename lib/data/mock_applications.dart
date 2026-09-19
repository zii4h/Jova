import '../models/application.dart';

/// Dev note:
/// This is a temporary mock data source for the application list. It is used to populate the UI with sample data while the backend is being developed.
/// WIll swap this out once Supabase is wired in (Proposal, 1.9).


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
      location: 'Makati, PH',
      jobType: 'Internship',
      salary: '₱15,000/mo',
      recruiterName: 'Dana Reyes',
      recruiterEmail: 'dana.reyes@northwindlabs.io',
      lastContacted: daysAgo(9),
    ),
    JobApplication(
      id: '2',
      company: 'Vantra Systems',
      role: 'Junior Full Stack Dev',
      appliedDate: daysAgo(14),
      status: ApplicationStatus.screening,
      source: 'Job board',
      location: 'Remote',
      jobType: 'Full-time',
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
      location: 'Quezon City, PH',
      jobType: 'Internship',
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
      location: 'Pasig, PH',
      jobType: 'Internship',
      salary: '₱18,000/mo',
      recruiterName: 'Marco Villanueva',
      recruiterEmail: 'marco.v@loopandco.com',
      recruiterLinkedIn: 'linkedin.com/in/marcov',
      lastContacted: daysAgo(2),
    ),
  ];
}
