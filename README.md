# SAKUin

A Flutter (Dart) implementation of the **SAKUin** personal-finance app, rebuilt from the
Figma file `menu-utama` (`T5GJXcFVj6rV1o7ELWbC1Y`).

The goal of this first pass is a **runnable, navigable prototype** of the designed flow —
not a production app. Every screen is real Flutter code (no screenshots, no image assets),
so it can be iterated on directly.

---

## What is implemented

| Screen | File | Notes |
|---|---|---|
| Onboarding (3 steps) | `lib/screens/onboarding_screen.dart` | Tilted category cards, dots, amber CTA, skip |
| App shell + bottom nav | `lib/screens/app_shell.dart`, `lib/widgets/app_bottom_nav.dart` | One nav component, 5 tabs, AI in the centre |
| Home | `lib/screens/home_screen.dart` | Greeting, wallet chips, total balance + hide, income/expense tiles, quick actions, history with search/filter, target carousel |
| Budget | `lib/screens/budget_screen.dart` | **New** — the Figma file had a Budget tab but no screen. Ring, stats, over-budget insight, per-category progress, add category |
| AI chat | `lib/screens/ai_screen.dart` | Empty state, suggestion cards, quick actions, working send + canned replies, thinking state, disclaimer |
| Analysis | `lib/screens/analysis_screen.dart` | Donut chart (custom painter), category legend, sortable history, targets |
| Profile / Settings | `lib/screens/profile_screen.dart` | Profile header, grouped rows, language sheet, log-out and delete-account confirmations |
| Add expense / income | `lib/screens/add_expense_screen.dart` | Keypad, live total, category chips, **date + wallet pickers** (missing in the design), save → updates the ledger |

State is a single `ChangeNotifier` (`lib/data/app_state.dart`) on purpose — no provider,
bloc or riverpod dependency, so `flutter pub get` on a clean machine just works.

---

## Design decisions taken from the design review

The Figma file had a few things that were fixed while building rather than copied:

1. **One currency format** — `Rp 1.500.000` everywhere. The file mixed `Rp 1.500.000.00`,
   `Rp. 1.500.000`, `Rp 17,525.000` and `Rp 1.000k`.
2. **One date format** — `15 Jan 2026` in lists, `15 Jan, 13.15` in the ledger. The file had
   `10/05/30`, `06/30`, `22.12.2026`, `Jan 2026` and `Today, 1.15 PM` in the same screen.
3. **Decimal comma** — `25,7%`, matching Indonesian convention, used consistently.
4. **Numbers that add up** — wallets sum to the total balance, categories sum to the month's
   spending (4.300.000), and income ≠ expenses (the file had both at Rp 250.000).
5. **Distinct category colours** — the donut used four shades of green; it now uses four
   distinguishable hues that also work for colour-blind users.
6. **One bottom nav** — the file had two competing patterns (4 tabs + floating FAB vs
   5 tabs with AI in the middle) and five hand-built copies. There is now a single widget.
7. **Semantic tokens** — brand, success, danger and neutral roles in
   `lib/theme/app_colors.dart`, built on the file's four local variables (Hijau Tua,
   Hijau Muda, Krem, Kuning) but extended with the roles that were missing.
8. **No third-party AI branding** — the ChatGPT/Claude glyphs in the file are replaced by
   a neutral sparkle mark.
9. **States, not just the happy path** — empty history, empty target list, disabled save
   button, thinking indicator, and confirmation dialogs for destructive actions.

---

## Running it

Requires Flutter 3.x (Dart SDK >= 3.0.0, records are used).

```bash
flutter pub get
flutter run
```

No assets, fonts or third-party packages are required.

### Project layout

```
lib/
  main.dart                 app entry + shell route
  theme/                    colours (tokens) and ThemeData
  data/                     models, mock data and app state
  utils/formatters.dart     rupiah / percent / date formatters
  widgets/                  shared UI (gradient backdrop, nav, chips, donut)
  screens/                  one file per screen
```

---

## Known gaps (next steps)

- No persistence — state resets on restart (needs `shared_preferences` or `drift`).
- No backend or auth; the AI replies are canned, not a real model call.
- Budget, target and category editing is create-only.
- Not yet checked against a real device for 360dp Android widths.
- Dark theme is a settings row only.
- No tests beyond widget smoke coverage.

These are the items from the design review that still need product decisions
(recurring bills, receipt scan, wallet sync, CSV export).
