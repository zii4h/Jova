# Jova

> A mobile-first job application tracker with a built-in conversion-funnel and
> source-breakdown analyst, for job seekers tired of spreadsheets.

**Live demo:** https://zii4h.github.io/Jova/ *(still work in progress)* 🛠️ <br>
**Demo video:** *(to be added soon)* 🛠️ <br>
**Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University <br>
**Author:** zii4h

> [!IMPORTANT]
> This repository is public for academic and portfolio purposes. It does not
contain real applicant or employer data, credentials, API keys, or other
private information.



---

## Screenshots

Screenshots will be added to `docs/assets/` as the application reaches a
presentable state.

<!--
| Dashboard | Calendar | Analytics |
| --- | --- | --- |
| ![Dashboard](docs/assets/screen-dashboard.png) | ![Calendar](docs/assets/screen-calendar.png) | ![Analytics](docs/assets/screen-analytics.png) |
-->

## What it does 

- **Log Applications:** Users log job applications with company, role, status, and source, plus optional location, job type, salary, description, and recruiter contact details.
- **Organize & Search:** Users group applications by stage on the Dashboard, utilizing search and per-stage filtering.
- **Track via Calendar:** Users view application history through a Calendar view, tapping any date to see what was logged that day.
- **Analyze Progress:** Users compute conversion funnels and source breakdowns locally on the Analytics screen, with an optional AI field-analysis panel (Gemini) on top.

## Application statuses

Jova tracks applications through five stages:

`Applied` → `Screening` → `Interview` → `Offer` / `Rejected`

## Built with

|  |  |
| --- | --- |
| Framework | Flutter (Dart) |
| State | `setState` (no external state package) |
| Storage | `sqflite`, local to the device/browser |
| UI | Material widgets with a custom Field Log design system |
| Other packages | `google_fonts` (Special Elite / JetBrains Mono / Inter), `http` (Gemini API calls), `device_preview` (phone-frame preview on the deployed link) |

## Running it yourself

```bash
flutter pub get
flutter run
```

To run the web version locally:

```bash
flutter run -d web-server --web-port 8080
```

Then open `http://localhost:8080`. Check your Flutter installation with
`flutter --version`.


## Environment Variables

Pass `GEMINI_API_KEY` via `--dart-define` at runtime to enable AI insights on the Analytics screen:

```bash
flutter run -d web-server --web-port 8080 --dart-define=GEMINI_API_KEY=your_key_here
```

Get a key at https://aistudio.google.com/apikey. No API keys or other secrets
are committed to this repository, and this value is not passed to the
deployed web build.

## Privacy and secrets

All job records stay entirely local via `sqflite` with zero server syncing. `GEMINI_API_KEY` is excluded from the web build because `--dart-define` compiles into public JS (the live demo shows the "no-key" fallback; check the demo video for the real feature). All sample data is completely fabricated.

## Project documentation

| Document | |
| --- | --- |
| [Proposal](docs/01-proposal.md) | The problem, users, and project scope |
| [Mockup and wireframes](docs/02-mockup.md) | Interface design and screen flow |
| [Design system](docs/03-design-system.md) | Colors, typography, spacing, and components |
| [Weekly reports](docs/04-weekly-reports.md) | Development progress |
| [Demo video](docs/05-demo-video.md) | Demo recording and walkthrough |
| [Security and privacy](docs/06-security-and-privacy.md) | Security and privacy checklist |

## Status & What's Next

### Current
- [x] Dashboard and application tracking interface
- [x] Application status management
- [x] Calendar view
- [x] Analytics view with local funnel and source breakdown
- [x] AI Insights panel (local-dev-only)
- [x] Responsive web build
- [x] GitHub Pages deployment

### Next
- [ ] Wire up sqflite persistence so data survives a restart
- [ ] Replace mock data with real database operations
- [ ] A responsive desktop layout
- [ ] Complete documentation, screenshots, and demo video

## Credits

- Packages: see [`pubspec.yaml`](pubspec.yaml)
- Flutter and Dart: Google
- No third-party assets, icons, or sounds beyond Google Fonts (Special Elite,
  JetBrains Mono, Inter) and Material Icons

## AI use

AI tools were used during documentation and implementation exploration -- including migrating the app into this repository's template structure. (Note: The Gemini API is also integrated directly into the app itself; see [What It Does](#what-it-does)).

## 🎗 License

Copyright © 2026 [zii4h](https://github.com/zii4h).
Released under the [MIT License](LICENSE).
