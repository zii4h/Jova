# Weekly reports

## Week 3 (September 28 – October 4, 2026)

**Done this week**
- Refined JOVA's branding and presentation, including the logo, favicon, browser title, and login screen.
- Added or refined the branded loading screen and web startup animation.
- Prepared final submission materials, including the presentation plan, README, and project documentation.
- Reviewed the deployed app's presentation and prepared screenshots and design-system material.

**In progress**
- Final checking of the deployed app, screenshots, presentation video, slides, and documentation before submission.

**Blocked or stuck on**
- Adjusting the Flutter web loading behavior and startup appearance.
- A local web preview port was occupied by another process during testing.

**Decisions made, and why**
- Kept the interface minimal and focused on tracking application statuses, analytics, and AI insights rather than expanding the feature set just before submission.
- Chose to share the presentation media through restricted Google Drive access in Canvas comments instead of publishing the video link in the public GitHub repository.

**Hours spent, roughly:** 7-8 hours

---

## Week 2 (September 21 – 27, 2026)

**Done this week**
- Implemented the login screen and Google OAuth authentication through Supabase, including session handling, an account menu, and sign-out.
- Added user-specific database ownership and Supabase Row Level Security (RLS), then tested data separation using two Google accounts.
- Configured default hiring stages: Applied, Screening, Interview, Offer, and Rejected.
- Added `highest_stage_reached` to support application stage history and funnel conversion calculations.
- Integrated on-demand Gemini Field Analysis through a Supabase Edge Function, keeping the AI credential on the server side.
- Improved the application form, dashboard chips, account menu, and desktop responsiveness of the Calendar view.
- Worked through the deployed GitHub Pages environment and authentication configuration.

**In progress**
- Checking production sign-in behavior, AI results, and overall responsiveness, alongside documentation updates.

**Blocked or stuck on**
- The GitHub Pages build initially lacked configuration from the locally ignored `env.json`; deployment variables and base-path configuration needed attention.
- Google OAuth redirect URLs needed to work with both the deployed `/Jova/` site and local development.
- Gemini Field Analysis returned a 502 error because the initially selected model was unavailable; changing the model used by the Edge Function resolved it.

**Decisions made, and why**
- Used Supabase Auth and RLS to keep each user's application records separate.
- Routed Gemini requests through a Supabase Edge Function instead of exposing the AI key in the Flutter web build.
- Recorded the highest hiring stage reached so the funnel could reflect progression rather than only current application status.

**Hours spent, roughly:** 5 hours

**Next week I will:**
- Refine the app's branding and loading experience, test the deployed build, and prepare the final presentation and documentation.

---

## Week 1 (September 14 – 20, 2026)

**Done this week**
- Developed the core job application tracker, including application entries, grouped hiring stages, and stage counts.
- Worked on the analytics view and on-demand AI insights and recommendations.
- Migrated existing work from the earlier development repository into the required JOVA template repository.
- Updated the project repository and documentation for the course requirements.
- Configured GitHub Pages with GitHub Actions and resolved an initial 404 by selecting GitHub Actions as the Pages source and rerunning deployment.

**In progress**
- Testing, documentation, and improvements to the app's features and deployment.

**Blocked or stuck on**
- Moving existing work into the new template without losing progress.
- The first GitHub Pages deployment returned a 404 until the Pages configuration and workflow were corrected.

**Decisions made, and why**
- Migrated to the required template to comply with the submission format while preserving earlier development work.
- Prioritized a usable manual job application tracker with grouped stages, analytics, and AI insights rather than expanding into automatic job applications or external job-board integrations.

**Hours spent, roughly:** 3 hours

