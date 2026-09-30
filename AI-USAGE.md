# AI Usage

I used AI throughout Jova mainly as a coding assistant when I was implementing something unfamiliar, debugging a problem, or figuring out how different services should connect. I did not treat its output as final code. I tested changes in the actual app, changed implementations when they did not behave the way I wanted, and kept the parts I could understand and maintain.

## 1. How I Used AI

### 1. Google Authentication

I had not set up Google OAuth with Supabase in Flutter before, so I used AI to help me work through the setup and understand which configuration belonged in Google Cloud, Supabase, and the Flutter app.

This was especially useful for the redirect flow because Jova had to work both locally and when deployed. After implementing it, I tested sign-in, sign-out, account switching, and session restoration with different Google accounts instead of assuming the OAuth flow was working correctly.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/016c5a308c4dfbb2b9cd49fe9917e943c7c84ad6)

### 2. Multi-User Supabase Database

Jova originally worked more like a single-user/demo app. I used AI while figuring out how to restructure the Supabase side so applications and custom stages belonged to the currently signed-in user.

This included adding `user_id` to the data flow and setting up Row Level Security. I tested this with two Google accounts by creating data in one account, switching accounts, and checking that the other user could not see it.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/fde4b2378f9ecfdcdaec61881354d8788447be0c)

### 3. Application Progress History

While working on Analytics, I ran into a problem with rejected applications. If an application reached Interview and was later changed to Rejected, Jova only knew that its current status was Rejected. That meant the funnel lost the fact that it had previously reached Interview.

I used AI to work through ways of storing that history, then implemented `highest_stage_reached`. The current status and furthest stage are now treated as two different pieces of information.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/3b605963bafc00490da89adc279a10b9d77a0d07)

### 4. Analytics and Gemini Field Analysis

For the conversion funnel, I changed the logic from counting only current statuses to using the furthest stage each application reached. I also added stage-to-stage percentages so the funnel shows progression rather than just another set of totals.

For Field Analysis, I used AI to help set up the request flow between Flutter, a Supabase Edge Function, and Gemini. I did not want the Gemini API key inside the Flutter web build, so the final flow became:

`Jova → Supabase Edge Function → Gemini → Jova`

I also worked on the prompt itself because the first goal was not just to have Gemini summarize the dashboard. I wanted it to look for patterns in the application data and return observations and a next action.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/3b605963bafc00490da89adc279a10b9d77a0d07)

### 5. UI and Responsive Improvements

I made several smaller UI changes while testing Jova, including the ALL collapse/expand behavior, required-field indicators, salary currency selection, account popup, sign-out confirmation, status-chip spacing, and Calendar responsiveness.

For some Flutter layout problems, I used AI to troubleshoot why the existing widgets were behaving incorrectly. I used the suggestions as references, then adjusted the code and styling to match the interface I already had.

Some examples were the account popup behavior, the two-step sign-out confirmation, dashboard status controls, and the Calendar layout stretching too much on desktop. I tested these visually in the running app and adjusted the generated suggestions to fit Jova's existing UI instead of replacing the design around them. 

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/66b29afb162b33cb2ef5aa9e58dc41fc0706b583)

### 6. Dashboard Search

I expanded the Dashboard search so it could search more than just the company and job title. I wanted the search to work with the information already stored in an application, including source, location, job type, salary, description, recruiter details, notes, status, and dates.

I used AI mainly when I was figuring out a clean way to make the different date formats searchable. I then added the date handling and tested the search using values from different application fields.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/ef7e311214f8d13d1483c39ad72008302cb9bb67)

---

## 2. Where the AI Got It Wrong

### 1. The Search Was Technically Working, but Barely Useful

One version of the search only checked `company` and `role`. The code worked, but that was not really the behavior I wanted from Jova. If I had already entered a location, source, recruiter, note, or other information into an application, I expected that information to be searchable too.

I caught this while testing the search with values I knew existed in the form but got no results.

I went back to the actual `JobApplication` fields and expanded the searchable data instead of keeping the limited implementation. Dates needed another adjustment because directly searching `DateTime.toString()` was not enough for normal searches such as a month name.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/ef7e311214f8d13d1483c39ad72008302cb9bb67)

### 2. Counting Current Status Gave the Wrong Meaning to the Funnel

The first approach to the conversion funnel treated the application's current status as its progression. I realized this breaks as soon as an application is rejected after reaching another stage.

For example:

`Applied → Screening → Interview → Rejected`

If Jova only checks the current status, that application becomes just "Rejected" and disappears from the Interview count. That makes the conversion funnel inaccurate.

I changed the data model by separating the current `status` from `highest_stage_reached`. The funnel now uses the latter, while the Dashboard can still show the application's actual current status.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/3b605963bafc00490da89adc279a10b9d77a0d07)

### 3. More Gemini Retries Did Not Fix Gemini

When Gemini started returning `503` errors because the model was under high demand, the retry logic suggested during development made it seem like retrying the request several times would make the integration reliable.

Testing showed that this was not really a fix. If Gemini itself is unavailable, Jova cannot make the service available by repeatedly sending the same request. It only makes the user wait longer before seeing the same failure.

I changed how I looked at the problem: Jova should handle an unavailable AI service properly instead of pretending it can prevent the error. The better behavior for this app is a limited retry and a clear temporary-unavailable state so the rest of Jova continues to work normally.

---

## 3. Who Wrote What

AI helped with a large part of the development process, but there are also parts of Jova that I directly implemented or changed myself. These are the parts I can trace through the code and explain without relying on the generated answer that originally helped me.

### Dashboard Search

I worked directly on the Dashboard search and its final behavior.

The search text comes from the `TextField` and updates `_query` through `setState()`. When the Dashboard rebuilds, I normalize the query and the application data to lowercase and use `contains()` to decide which applications stay in the visible list.

I expanded the searchable values to match the fields Jova actually stores. I also added the month/date handling because I wanted dates to be searchable in formats a user would naturally type.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/ef7e311214f8d13d1483c39ad72008302cb9bb67)

### Application Progress and Conversion Logic

I worked through the progression behavior because I knew what I wanted the Analytics funnel to represent: applications that **reached** each stage, not only applications currently sitting in that stage.

`status` tells Jova where an application is now. `highest_stage_reached` tells it how far that application got. When an application moves forward, the highest stage can increase. Changing it to Rejected does not erase that previous progress.

The Analytics screen then uses those stages to calculate the counts and the percentage that moved from one stage to the next.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/3b605963bafc00490da89adc279a10b9d77a0d07)

### UI Changes

I made and adjusted several of Jova's smaller interactions instead of treating the generated UI as fixed.

This includes the behavior of the ALL status control, required-field indicators, salary currency selection, account popup, sign-out confirmation, status-chip spacing, and Calendar responsiveness. Most of these were small changes, but they required me to work with the existing widgets and state without breaking the rest of the interface.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/66b29afb162b33cb2ef5aa9e58dc41fc0706b583)

### Testing and Integration

A large part of my own work was also testing whether the separate pieces actually worked together.

For authentication and Supabase, I tested Jova with two different Google accounts and checked whether their application data stayed separate. For Analytics, I changed application statuses in different sequences to check whether the funnel still represented their previous progress. For Field Analysis, I tested the actual Edge Function responses instead of only checking whether the Flutter code compiled.

This testing is also how I found several of the problems documented above. I did not consider a generated implementation finished just because it ran without a compile error.

**Commit:** [View commit](https://github.com/zii4h/Jova/commit/fde4b2378f9ecfdcdaec61881354d8788447be0c)

---

## AI Credit

AI tools were used during Jova's development for implementation guidance, debugging, code suggestions, and learning technologies I had not used before. I reviewed and tested the generated suggestions in the actual application and changed them when they did not match the behavior I wanted or failed during testing.

The parts identified in this document are the parts of the project I worked through and can explain myself.