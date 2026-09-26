# J O V A 
> *Track Every Step of Your Job Search*

Jova is a mobile-first job application tracker built for job seekers who want a simpler way to keep track of where they've applied and what happens next.

Instead of maintaining a spreadsheet, Jova gives you one place to log applications, follow their progress, revisit important dates, and understand how your job search is going.

> [!IMPORTANT]
> This repository is public for academic and portfolio purposes. It does not contain real applicant or employer data, credentials, API keys, or other private information.

- **Live demo:** https://zii4h.github.io/Jova/ <br>
- **Demo video:** *(to be added soon)* 🛠️ <br>
- **Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University <br>
- **Author:** zii4h


## PREVIEW

| Dashboard, Calendar, Analytics |
| --- |
| <img width="2000" height="1414" alt="Jova Dashboard, Calendar, and Analytics" src="https://github.com/user-attachments/assets/35feb8bd-023a-4df9-ac99-79810b785ded" /><br><br><img width="2000" height="1414" alt="Jova Dashboard, Calendar, and Analytics" src="https://github.com/user-attachments/assets/5828b852-d826-4461-af74-a90f56793adf" /> |

## WHAT YOU CAN DO WITH JOVA

⭐ Keep track of every application statuses

- Save the important details of each job application, including the company, position, status, source, salary, location, notes, and recruiter information.

⭐ Follow applications as they progress

- Applications are grouped and searchable into the default five statuses which you can modify yourself:

- `Applied` → `Screening` → `Interview` → `Offer` / `Rejected`

⭐ Understand your progress

- Analytics turns your application history into a conversion funnel, showing how many applications are making it from Applied to Screening, Interview, and Offer.

⭐ Find where your applications come from

- Source Breakdown shows where you're finding opportunities, making it easier to compare sources such as LinkedIn, job boards, company websites, and referrals.

⭐ Get a second look at your job search

- Field Analysis uses Artificial Intelligence to look at your application activity and provide observations and suggested next actions.

⭐ Your applications stay with your account

- Sign in with Google to access your own Jova workspace. Applications and preferences are kept separate between accounts.

---

## HOW TO USE

1. Sign in using **Continue with Google**.
2. Select **Add Application** to log a job application.
3. Update its status as it moves through the hiring process.
4. Use the **Dashboard** to search, filter, edit, or review applications.
5. Open **Calendar** to view and keep track of applications by date.
6. Open **Analytics** to see your conversion funnel, source breakdown, and Field Analysis.

---

## RUNNING JOVA LOCALLY

### Requirements

Jova was developed with:

- Flutter 3.41.9
- Dart
- Supabase

Clone the repository:

~~~bash
git clone https://github.com/zii4h/Jova.git
cd Jova
~~~

Install the dependencies:

~~~bash
flutter pub get
~~~

Create an `env.json` file in the project root:

~~~json
{
  "SUPABASE_URL": "your_supabase_project_url",
  "SUPABASE_PUBLISHABLE_KEY": "your_supabase_publishable_key"
}
~~~

Then run:

~~~bash
flutter run -d chrome --web-port=8080 --dart-define-from-file=env.json
~~~

The login screen should appear once the application starts successfully.

---

## STRUCTURE

~~~text
lib/
├── main.dart
├── models/
├── screens/
├── services/
├── theme/
└── widgets/
~~~

- `models/` — application data models and statuses
- `screens/` — Dashboard, Calendar, and Analytics screens
- `services/` — database and external service communication
- `theme/` — Jova's visual design system
- `widgets/` — reusable interface components

Additional project documentation is available in [`docs/`](docs/).

---

## PRIVACY & SECURITY

Jova uses Google authentication through Supabase. Each account can only access its own application data.

Gemini-powered Field Analysis is handled through a **Supabase Edge Function** rather than directly inside the Flutter application. The Gemini API key is stored as a server-side secret and is not included in the public web build.

---

## KNOWN ISSUES & WHAT'S NEXT

Jova is currently in active development as a final project.

- Continue testing across mobile and desktop layouts
- Complete final UI polish
- Update final screenshots
- Complete the demo video
- Continue testing authentication and application data handling

---

## DOCUMENTATION

| Document | Description |
| --- | --- |
| [Proposal](docs/01-proposal.md) | The idea and problem behind Jova |
| [Mockup and wireframes](docs/02-mockup.md) | Early interface design and screen flow |
| [Design system](docs/03-design-system.md) | Jova's visual system |
| [Weekly reports](docs/04-weekly-reports.md) | Development progress |
| [Demo video](docs/05-demo-video.md) | Application walkthrough |
| [Security and privacy](docs/06-security-and-privacy.md) | Security and privacy documentation |

---

## AI USAGE

AI tools were used during parts of Jova's development and documentation process. See [`AI-USAGE.md`](AI-USAGE.md) for the complete disclosure.

Jova's **Field Analysis** is also an AI-powered application feature using Gemini. This is separate from AI assistance used during development.

---

## CREDITS

Built with Flutter, Dart, Supabase, Google OAuth, and Gemini.

Packages used by the project are listed in [`pubspec.yaml`](pubspec.yaml).

---

## 🎗 LICENSE

Copyright © 2026 [zii4h](https://github.com/zii4h).

Released under the [MIT License](LICENSE).
