# Proposal

## The problem, in one sentence
Tracking job applications across spreadsheets and separate notes makes it difficult to see each application's current hiring stage and overall progress in one place.

## Who it is for
JOVA is intended for students, fresh graduates, and job seekers who apply to multiple positions and need a straightforward way to organize their application statuses.

## Core features
- **Google sign-in:** Authenticate through Supabase Auth.
- **Application tracking:** Add and manage job application entries, including company, position, and hiring status.
- **Hiring stages:** Group applications by stage and manage stage names and ordering.
- **Dashboard:** View applications and counts by stage.
- **Calendar:** View application-related entries in a calendar interface.
- **Analytics:** Summarize the applications currently recorded in the tracker.
- **AI Insights & Recommendations:** Request on-demand analysis using Gemini, based on available application data.

## Out of scope, and why
- **Automatic application submission or email synchronization:** JOVA is a manual tracker, not a job-board integration.
- **Real-time recruiter or employer updates:** The app cannot verify external hiring decisions automatically.
- **Historical trend tracking:** The current analytics focus on recorded application data rather than a complete history of every status change.
- **Guaranteed job-search outcomes:** AI output is advisory, not a hiring prediction.

These limits keep the project focused on a functional and manageable tracking workflow.

## Data the app remembers, and where it is saved
- Google-authenticated account identity and session: Supabase Auth.
- Job application entries and their assigned stages: Supabase PostgreSQL database.
- User-defined hiring stage settings: Supabase PostgreSQL database.
- AI-generated analysis: requested through the application's AI service; 
- Sample records for development: `lib/data/mock_applications.dart` (not a substitute for the live database).

## Risks
- **Privacy:** Job-search records may contain personal or employment-related information. Auth and database access controls must limit access to the owning user.
- **Misconfiguration:** Incorrect RLS policies or exposed privileged credentials could expose data.
- **AI accuracy:** Gemini may generate inaccurate or overly broad recommendations. Results should be reviewed by the user.
- **Availability:** Supabase, Google sign-in, and the AI endpoint require network access and can fail.
- **Scope:** Additional features can complicate testing and delivery.

## Changes since the last version
- **September 18–20, 2026:** Migrated the project from an earlier development repository into the required JOVA template for submission and deployment.
- **September 2026:** Kept the app focused on application tracking, grouped stages, analytics, and on-demand AI recommendations.
- **October 3–4, 2026:** Improved branding, browser title/favicon, login appearance, and startup loading experience.
