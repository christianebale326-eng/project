# CAPMATCH — Flutter Web Prototype

**Capstone, Thesis, Adviser and Chairman Matching System**
A frontend prototype that auto-matches senior IT students to a thesis/capstone **adviser, defense panel, and chairman** using **real TF-IDF vectorization + cosine similarity computed in pure Dart**, then auto-schedules defenses. No backend — all data lives in app state.

---

## What's inside

- **Real matching engine** (`lib/utils/matching_engine.dart`): tokenization + stopword removal, normalized term frequency, smoothed IDF, TF-IDF vectors, and cosine similarity — the match scores you see are genuinely computed, not faked.
- **Four role dashboards** with a login screen and a live role switcher:
  - **Student** — Capstone Request Form (submit a topic → live ranked matches), auto-assigned adviser/chairman/panel with 0–1 match scores, defense schedule.
  - **Faculty** — research profile + keywords, adviser/panel capacity sliders, incoming assignments with scores, decline → reassign.
  - **Coordinator** — department matching monitor, validate, load-balance bar chart.
  - **Administrator** — user accounts, matching config (threshold / response window), system-stats charts, faculty load, audit logs.
- **Design** — Material 3, amber accent on warm off-white, deep-slate navigation, Fraunces (serif display) + Plus Jakarta Sans (sans) via `google_fonts`, animated match-score bars, staggered fade/slide reveals, responsive sidebar (desktop) / drawer (mobile).

## Tech

- `provider` for state management
- `fl_chart` for the load-balance and statistics charts
- `google_fonts` for typography

> Note: navigation is driven by app state (role + nav index) inside a responsive `ShellPage` rather than `go_router`. This keeps the single-window dashboard robust and dependency-light; it can be swapped for `go_router` later without touching the pages.

---

## Run it

You need the Flutter SDK installed (Flutter 3.x, Dart 3.x) with web enabled.

```bash
# 1. Create a fresh Flutter project to generate the web/ + platform scaffolding
flutter create capmatch_app
cd capmatch_app

# 2. Replace the generated lib/ and pubspec.yaml with the ones from this archive
#    (copy this project's lib/ folder and pubspec.yaml over the generated ones)

# 3. Fetch dependencies
flutter pub get

# 4. Run on Chrome
flutter run -d chrome
```

Alternatively, if you already have an empty project folder, just drop `lib/` and `pubspec.yaml` in, run `flutter create .` to add the `web/` scaffold, then `flutter pub get` and `flutter run -d chrome`.

## Project structure

```
lib/
  main.dart                 App entry, provider + theme + login/shell switch
  theme.dart                Color palette, Material 3 theme, Fraunces helper
  models/
    faculty.dart            Faculty (with TF-IDF `document` getter)
    student.dart            Student (with query `document` getter)
  data/
    sample_data.dart        6 faculty + 5 students seed data
    nav.dart                Nav items + role metadata
  utils/
    matching_engine.dart    TF-IDF + cosine similarity, ranking, auto-assign
  state/
    app_state.dart          ChangeNotifier app state
  widgets/
    chrome.dart             AppSidebar, TopBar (role switcher, notifications)
    app_card.dart           AppCard, PageTitle, InfoRow, Field
    indicators.dart         MatchScoreBar, StatusBadge, Pill, KeywordChips
    stat_card.dart          StatCard
    assignment_views.dart   PersonRow, AssignmentResult
    responsive_grid.dart    ResponsiveGrid
    reveal.dart             Staggered fade/slide-up animation
  pages/
    login_page.dart
    shell_page.dart         Responsive sidebar/drawer + body router
    student_pages.dart
    faculty_pages.dart
    coordinator_pages.dart
    admin_pages.dart
```

## Thesis note

Your proposal documents a **React.js** frontend (Chapter 3 — software requirements, tools table, and the system-architecture figure). If you adopt this Flutter Web frontend, update those sections so the documented stack matches the implementation. The matching logic itself (TF-IDF + cosine) can remain a Python/scikit-learn backend; only the presentation layer changes to Flutter.

## Note on dependency versions

Pinned: `provider ^6.1.2`, `google_fonts ^6.2.1`, `fl_chart ^0.68.0`. The chart code targets the fl_chart 0.68 API. If `flutter pub get` resolves a newer major version of fl_chart and the charts fail to compile, pin it back to `0.68.0` in `pubspec.yaml`.
