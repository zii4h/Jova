# Jecord — Field Log scaffold

This is a first-look scaffold, not the final app: an in-memory `List<JobApplication>`
stands in for Supabase (see Proposal 1.9/1.10), and there's no auth yet. It's meant to
let you see and feel the "Field Log" direction — paper background, index cards,
rubber-stamp status tags — running for real on device/emulator.

## What's here

- `lib/theme/field_log_theme.dart` — every color/type/spacing token from the Part 3 doc
- `lib/models/application.dart` — the `JobApplication` model + `ApplicationStatus` enum
- `lib/data/mock_applications.dart` — seed data so the app isn't empty on first run
- `lib/widgets/index_card.dart`, `status_stamp.dart` — the reusable atom/molecule
- `lib/widgets/application_form_sheet.dart` — the guided add/edit form (bottom sheet)
- `lib/widgets/floating_dock.dart` — the 3-button floating bottom nav
- `lib/screens/dashboard_screen.dart` — main list (Part 2 "Dashboard")
- `lib/screens/calendar_screen.dart` — month view, dots on days with entries, tap a day to see that day's applications
- `lib/screens/analytics_screen.dart` — local conversion funnel (Applied → Screening → Interview → Offer) + source breakdown, no AI call yet
- `lib/main.dart` — app shell holding the shared application list + tab state

## How to drop it into your existing project

1. Copy everything under `lib/` into your project's `lib/`, replacing the existing `main.dart`.
2. Add the one new dependency to your `pubspec.yaml` (or just copy this one over yours if you haven't customized it):
   ```yaml
   dependencies:
     google_fonts: ^6.2.1
   ```
3. Run:
   ```
   flutter pub get
   flutter run
   ```

## What's intentionally not wired up yet

- Data doesn't persist — it resets to the mock seed on every restart. That's the Supabase step from your Proposal.
- Analytics funnel counts "reached at least this stage" from current status only, since there's no status-history tracking yet — good enough to see the shape, worth revisiting once you store status changes over time.
- The AI-generated summary text isn't in here — the funnel and source breakdown are computed locally per Objective 5, exactly as scoped.
