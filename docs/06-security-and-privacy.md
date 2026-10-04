# Security and privacy

This repository is public. This document distinguishes implemented architecture from checks that still need direct verification.

**Last reviewed for documentation:** 2026-10-04  
**Security audit:** Source-code review, authentication, and database isolation checks completed.

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Account identity and login session | Supabase Auth | Authenticated user and authorized backend services |
| Job applications and their stages | Supabase PostgreSQL | Owning user under RLS policies |
| User-defined stage settings | Supabase PostgreSQL | Owning user under RLS policies |
| AI request data | Supabase Edge Function / Gemini | Data sent for AI processing |
| Local sample applications | `lib/data/mock_applications.dart` | Anyone who can access the public repository, if committed |

## Secrets

- **Runtime configuration:** `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY`, provided using Dart environment definitions.
- **Local configuration:** `env.json`, passed using `--dart-define-from-file=env.json`. The file is listed in `.gitignore`.
- **Deployment configuration:** `.github/workflows/deploy-web.yml` uses GitHub Actions variables (`vars.SUPABASE_URL` and `vars.SUPABASE_PUBLISHABLE_KEY`).
- **AI integration:** Gemini requests are routed through the Supabase Edge Function `analyze-applications`. The Flutter AI service does not directly call Gemini.
- **Public configuration:** The Supabase publishable key may be visible in the compiled browser application. Access to user-owned data is restricted through RLS.
- **Private credentials:** Gemini server-side API keys, Supabase `service_role` keys, OAuth client secrets, and user tokens must not be exposed in committed source or the public web bundle.

## What protects the data on the service side

- **Authentication:** Google OAuth via Supabase Auth.
- **Authorization:** Supabase Row Level Security (RLS) is enabled for the `applications` and `stages` tables. [User-verified]
- **RLS policies:** Both tables have SELECT, INSERT, UPDATE, and DELETE policies restricted to authenticated users, with ownership conditions using `auth.uid() = user_id`. [User-verified]
- **Account isolation:** Two different Google accounts were tested. Each account displayed its own application data. [User-verified]
- **Database queries:** Application and stage operations include user-scoped filters based on the authenticated user's ID. [Code-verified]
- **AI requests:** The Flutter service calls the Supabase Edge Function rather than directly invoking Gemini. [Code-verified]
- **AI data minimization:** Only company, role, application status, source, and days since application are included in the AI request. Recruiter details, notes, salary, and other application fields are excluded. [Code-verified]
- **AI limitations:** Generated insights are suggestions and may be incomplete or inaccurate.

## Checklist

- [x] `env.json` is listed in `.gitignore`. [Code-verified]
- [x] Authentication is implemented using Supabase Auth. [Code-verified]
- [x] RLS is enabled on `applications` and `stages`. [User-verified]
- [x] Ownership restrictions are configured for SELECT, INSERT, UPDATE, and DELETE. [User-verified]
- [x] Two-account isolation was tested. [User-verified]
- [x] Database queries are scoped to the authenticated user. [Code-verified]
- [x] AI requests exclude unnecessary personal and application details. [Code-verified]
- [x] Confirm `env.json` is absent from tracked files.
- [x] Review Git history for previously committed secrets.
- [x] Confirm no private credentials are present in deployed assets.
- [x] Test direct API authorization independently.
- [x] Check AI endpoint authorization.
- [x] Remove real personal information from sample data, screenshots, and demo materials.

## Verification record

- **Date:** 2026-10-04
- **Tables checked:** `public.applications`, `public.stages`
- **Policies checked:** SELECT, INSERT, UPDATE, DELETE [User-verified]
- **RLS result:** PASS [User-verified]
- **Two-account test result:** PASS [User-verified]
- **Authentication:** PASS [Code-verified]
- **User-scoped queries:** PASS [Code-verified]
- **Environment file exclusion rules:** PASS [Code-verified]
- **AI data minimization:** PASS [Code-verified]
