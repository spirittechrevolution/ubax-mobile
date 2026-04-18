# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UBAX Mobile — a Flutter real estate app targeting Côte d'Ivoire (African market). Currently a UI-first prototype with hardcoded data; no backend integration yet.

## Current Phase: UI Prototype

The app is intentionally UI-first with hardcoded data. When asked to add a feature:
- Default to hardcoded mock data matching the eventual API shape
- Place mocks in `lib/features/<feature>/data/mock_<entity>.dart`
- Design widgets to accept data via constructor (no fetches inside widgets) so a backend swap is trivial later
- Do NOT introduce HTTP calls, Dio, or Firebase SDK until explicitly asked

## Build & Run Commands

```bash
flutter run                    # Run on connected device/emulator
flutter build apk              # Build Android APK
flutter build ios              # Build iOS
flutter analyze                # Static analysis (uses flutter_lints)
flutter test                   # Run tests (minimal coverage currently)
flutter pub get                # Install dependencies
```

Code generation dependencies (freezed, json_serializable) are declared but not yet used. When activated:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

**Feature-driven structure** under `lib/features/`:
- `onboarding/` — Splash, language selection, onboarding flow, app routing (`AppStart`)
- `auth/` — Login, signup, OTP, password recovery (7 screens). Empty `data/`, `domain/`, `presentation/` layers scaffolded for future BLoC integration.
- `customer/` — Main app after auth: `home/`, `hotels/`, `favorites/`, `chat/`, `profile/`

**Shared code** under `lib/core/`:
- `storage/app_prefs.dart` — SharedPreferences wrapper (onboarding state, language)
- `widgets/` — Reusable components (e.g., `OrangeButton`)

**Theme** under `lib/theme/`:
- `app_colors.dart` — Palette (primary orange `#E87D1E`, dark `#1A3047`)
- `app_theme.dart` — Material 3 light theme, Lexend font family

**Entry point**: `main.dart` → `EasyLocalization` wrapper → `AppStart` (conditional routing based on prefs)

## Key Patterns

- **Navigation**: Manual `Navigator.push(MaterialPageRoute(...))`, no named routes
- **State**: Local StatefulWidget state only. BLoC (`flutter_bloc`) and GetIt are dependencies but not wired up yet.
- **Localization**: `easy_localization` with JSON files in `assets/translations/` — supports fr (default), en, es, de, hi
- **Country picker**: Custom `AfricaCountryCodePicker` widget with 54 African countries (in auth)
- **HomeScreen**: Bottom navigation with 5 tabs (Accueil, Favoris, Chat, Hôtels, Profil)

## Conventions

- French is the default/fallback locale
- UI text must use localization keys via `'key'.tr()`
- Custom font: Lexend (weights: 400, 500, 600, 700)
- Platform targets: Android, iOS (also configured for web, macOS, Linux, Windows)
- File naming: `snake_case.dart`; widget classes: `PascalCase`
- New customer screens: `lib/features/customer/<feature>/<feature>_screen.dart`

## Localization Rules

Translation files: `assets/translations/{fr,en,es,de,hi}.json`

When adding a new key:
1. Add it to `fr.json` first (source of truth)
2. Add the same key to all 4 other files with a best-effort translation or the French fallback
3. Use nested keys for grouping: `auth.login.title`, `home.tabs.favorites`
4. Never call `.tr()` on a key that doesn't exist in `fr.json`

## Guardrails

**Do:**
- Always use localization keys for any user-facing text, even in quick prototypes
- Reuse `OrangeButton` and theme colors from `app_colors.dart` rather than creating new buttons or inline hex codes
- Keep Lexend as the sole font family
- Match the existing feature-driven structure when adding code

**Don't:**
- Don't hardcode French (or any language) strings in widgets
- Don't add new state management libraries — BLoC + GetIt are the chosen path once wiring begins
- Don't create named routes or introduce a router package (go_router, auto_route…) without discussion
- Don't modify generated files (`*.g.dart`, `*.freezed.dart`) when build_runner is eventually activated
- Don't commit API keys, tokens, or `.env` files
- Don't introduce new dependencies without flagging them first

## Git Workflow

- Never run `git push --force`
- Don't commit on your own; propose a commit message and wait for approval
- Commit style: short imperative, English or French — e.g. "Add favorites empty state" or "Corriger alignement OTP"

## When Unsure

If a request conflicts with these rules, or if the "right" answer depends on a choice not yet documented (e.g. how to structure a new data layer, which package to use), ASK before acting. A 30-second clarification is cheaper than a 300-line refactor.
