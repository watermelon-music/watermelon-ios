# 🍉 Watermelon — Flutter Implementation Plan

A dark-first music-streaming app built in Flutter from the **Watermelon Dark** design
handoff. This plan turns the 10 designed screens + 2 shared components into a working
Flutter app, in reviewable phases.

---

## 0. Decisions (locked)

| Decision | Choice | Implication |
|---|---|---|
| **Playback** | UI-only **mock** player | No real audio. A simulated progress timer + play/pause state. Player logic sits behind a `PlayerController` so real audio (`just_audio`) can be added later without UI changes. |
| **Backend / Auth** | **All mock / local** | Hard-coded sample data (the exact tracks/playlists/stations/plans from the design). Login/Register buttons navigate to Home — no real auth. Data sits behind repository classes so a real backend can drop in later. |
| **State management** | **Riverpod** (`flutter_riverpod`) | Player state, likes, and the now-playing track are shared across screens (mini-player ↔ now-playing ↔ tab bar) via providers. |
| **Platforms** | **iOS + Android** | Cross-platform. Design is iOS-styled (Dynamic Island notch, home indicator) — those are *real device chrome*, so we do **not** draw them; we use `SafeArea` + the real status bar instead. |
| **Navigation** | `go_router` | Declarative routes; clean auth → shell (tabbed) → detail flow. |
| **Fonts** | `google_fonts` (Inter + JetBrains Mono) | Avoids bundling .ttf files. (Can switch to bundled fonts later for offline/size.) |

---

## 1. Source of truth — the design handoff

Everything is already specified in `~/Downloads/watermelon-design/`:

- **`flutter_handoff/lib/theme/`** — `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`,
  `app_theme.dart`, `app_assets.dart`. **Copy these in verbatim** — they are the design tokens.
- **`flutter_handoff/assets/`** — `images/` (with `2.0x/`, `3.0x/` density variants) + `icons/` (28 SVGs).
- **`flutter_handoff/branding/`** — launcher icons, adaptive icon, splash logo.
- **`flutter_handoff/pubspec_snippet.yaml`** — assets/fonts/launcher/splash wiring.
- **`Watermelon Music App.dc.html`** — the pixel reference for all 10 screens (exact paddings,
  sizes, colors, copy, sample data). **This is the visual spec — match it.**
- **`MiniPlayer.dc.html`** / **`TabBar.dc.html`** — the two shared components.
- **`uploads/watermelon-DESIGN.md`** — the design-system rationale.

### Design rules to honor (non-negotiable)
- **Dark only.** Never introduce light surfaces.
- **Red is precious** (`#FF1A1A`): exactly one red action per view (primary CTA / now-playing / active tab).
- **Min tap target 44px** (`AppSize.minTapTarget`).
- **Mono font for all numbers** — timecodes, durations, track numbers (`AppType.mono`).
- Corner radii: pill buttons, 14–18 for cards/inputs, 46 for sheets/hero.
- Background canvas `#050505`; surfaces `#0C0C0D` / `#1A1A1A`.

---

## 2. The 10 screens + 2 components

| # | Screen | Route | Key elements |
|---|---|---|---|
| 01 | **Onboarding** | `/onboarding` | Full-bleed `bg-field-tall` hero, logo + WATERMELON wordmark, "Feel the **juice**" display type (red→orange gradient), "Get started" CTA, page dots. |
| 02 | **Login** | `/login` | Back button, logo, "Welcome back", email + password fields (mail/lock/eye icons), "Forgot password?", red "Log in" CTA, divider, Apple + Google buttons, "Create account" link. |
| 03 | **Register** | `/register` | Back button, "Create your account", Name/Email/Password fields, **password-strength meter** (4 bars + "Strong"), Terms checkbox, "Create account" CTA. |
| 04 | **Home** | `/home` (tab) | Top "Good evening / Avery" + bell + avatar, filter chips (All/Music/Podcasts), 2-col "jump back in" grid, "Made for Avery" feature card (`bg-river` + play FAB), "New releases" 2-col grid. Mini-player + tab bar. |
| 05 | **Search** | `/search` (tab) | "Search" title, search field, "Recent searches" list (+ Clear), "Browse all" 2-col colored category tiles with rotated artwork. Tab bar. |
| 06 | **Now Playing** | `/player` | Wine→black gradient, chevron-down + "Playing from playlist" + more, square artwork, title/artist + like, scrubber (mono timecodes), shuffle/prev/**play-78px**/next/repeat, bottom row (lyrics/devices/queue). |
| 07 | **Radio** | `/radio` (tab) | "Radio" title, "Watermelon FM" LIVE hero card (animated pulse dot), "Popular stations" list (circular play btns), "Genre radio" wrap chips. Tab bar. |
| 08 | **Playlist** | `/playlist/:id` | 430px `bg-field-tall` hero w/ gradient, back + more, "Sunday Slice" title + desc + meta, like/download/share row + red play FAB, scrolling track list (mono track #, art, title/artist, like, mono duration; now-playing row tinted). Mini-player. |
| 09 | **Profile** | `/profile` (tab) | Settings gear, circular avatar, name/@handle, stats (Followers/Following/Playlists), "Edit profile" pill, Premium upgrade gradient card, "Your playlists" 2-col grid, settings list (Account/Playback/…). Tab bar. |
| 10 | **Subscription** | `/subscription` | Close btn, logo, "Watermelon **Premium**", Monthly/Annual toggle, 3 plan cards (radio-select, "MOST POPULAR" badge), perks checklist, "Start 1-month free trial" CTA, fineprint. |
| — | **MiniPlayer** | component | Floating frosted bar above tab bar: progress tint, cover, title/artist, heart, play/pause. Tapping opens Now Playing. |
| — | **TabBar** | component | 4 tabs: Home / Search / Radio / Profile. Active = red. Custom SVG icons w/ fill on active. |

> Note on tab labels: the design's 4th tab icon is a person labeled **"Profile"** (the HTML
> internally calls it `library`). We use **Profile** as the visible label, routing to screen 09.

---

## 3. Project structure

```
lib/
├─ main.dart                      # ProviderScope + MaterialApp.router + AppTheme.dark
├─ router.dart                    # go_router: auth flow + ShellRoute (tab scaffold)
├─ theme/                         # ← copied verbatim from handoff
│  ├─ app_colors.dart
│  ├─ app_typography.dart
│  ├─ app_spacing.dart
│  ├─ app_theme.dart
│  └─ app_assets.dart
├─ models/
│  ├─ track.dart                  # title, artist, art, duration, isLiked
│  ├─ playlist.dart               # title, desc, cover, owner, saves, duration, tracks
│  ├─ station.dart                # name, genre, listeners, art
│  ├─ category.dart               # label, color, image
│  └─ plan.dart                   # name, sub, monthly, annual, featured
├─ data/
│  ├─ mock_data.dart              # all sample data, lifted from the HTML reference
│  └─ repositories/               # MusicRepository, etc. (interfaces over mock_data)
├─ state/                         # Riverpod providers
│  ├─ player_controller.dart      # PlayerController (mock): current track, playing,
│  │                              #   position timer, play/pause/seek/next/prev, like
│  ├─ likes_provider.dart         # liked-track set (shared Home/Playlist/Player)
│  └─ subscription_provider.dart  # monthly/annual + selected plan
├─ widgets/                       # shared, reusable
│  ├─ app_icon.dart               # SvgPicture wrapper w/ tint (uses AppAssets icons)
│  ├─ primary_button.dart         # red pill CTA w/ glow
│  ├─ mini_player.dart            # component
│  ├─ watermelon_tab_bar.dart     # component
│  ├─ track_tile.dart, category_card.dart, station_tile.dart, section_header.dart …
│  └─ phone_chrome.dart           # status-bar styling helper (NOT fake notch)
└─ screens/
   ├─ onboarding/onboarding_screen.dart
   ├─ auth/login_screen.dart
   ├─ auth/register_screen.dart
   ├─ home/home_screen.dart
   ├─ search/search_screen.dart
   ├─ player/now_playing_screen.dart
   ├─ radio/radio_screen.dart
   ├─ playlist/playlist_screen.dart
   ├─ profile/profile_screen.dart
   ├─ subscription/subscription_screen.dart
   └─ shell/app_shell.dart        # Scaffold w/ IndexedStack tabs + mini-player + tab bar
```

---

## 4. Phased delivery

Each phase ends in a **compiling, runnable** app. Review/commit at each ✅.

### Phase 1 — Project scaffold & design system ✅
- `flutter create` into the repo (org `fm.watermelon`, name `watermelon`, platforms ios+android).
- Merge `pubspec_snippet.yaml`; add `flutter_riverpod`, `go_router`, `google_fonts`, `flutter_svg`.
- Copy `theme/`, `assets/images/`, `assets/icons/`, `assets/branding/` from the handoff.
- Wire `AppTheme.dark` into `MaterialApp.router`; force dark status bar.
- Adapt `app_theme.dart`/`app_typography.dart` to pull Inter + JetBrains Mono via `google_fonts`.
- Smoke screen renders with theme colors + fonts. App builds on a simulator.

### Phase 2 — Models, mock data & Riverpod state ✅
- Define `models/` and `mock_data.dart` (copy the exact arrays from the HTML `renderVals()`:
  tracks, jumpBack, newReleases, recents, categories, stations, genres, myPlaylists, plans, perks).
- `PlayerController` (StateNotifier): `currentTrack`, `isPlaying`, `position`, `duration`;
  `play(track)`, `toggle()`, `seek()`, `next()`, `prev()`; a `Timer` advances `position` while playing.
- `likesProvider` (set of liked track ids) + `subscriptionProvider`.
- No UI yet beyond a debug harness — verify state transitions.

### Phase 3 — Shared components & navigation shell ✅
- `AppIcon`, `PrimaryButton`, `SectionHeader`, `TrackTile`, `CategoryCard`, `StationTile`.
- `WatermelonTabBar` (4 tabs, red active, SVG icons w/ active fill) — match `TabBar.dc.html`.
- `MiniPlayer` (frosted bar, progress tint, cover/title/artist/heart/play, tap → `/player`) — match `MiniPlayer.dc.html`.
- `AppShell`: `IndexedStack` of the 4 tabs + persistent mini-player + tab bar.
- `router.dart`: `/onboarding → /login ↔ /register → shell(/home,/search,/radio,/profile)`,
  plus `/player`, `/playlist/:id`, `/subscription`.

### Phase 4 — Auth & onboarding screens (01–03) ✅
- **Onboarding**: hero image + gradient scrim, logo/wordmark, gradient display type, CTA, dots.
- **Login**: fields, social buttons, links. "Log in" → `/home`.
- **Register**: fields, password-strength meter, Terms checkbox, "Create account" → `/home`.
- (Fields are presentational/mock; no validation backend.)

### Phase 5 — Home & Search (04–05) ✅
- **Home**: greeting header, chips, jump-back grid, "Made for Avery" feature card (play → `/player`),
  new-releases grid, header glow gradient.
- **Search**: search field (non-functional input ok, or local filter as stretch), recent searches,
  "Browse all" colored category tiles with rotated artwork.

### Phase 6 — Now Playing & Playlist (06, 08) ✅
- **Now Playing**: wine gradient, header, artwork, title/artist + like, scrubber bound to
  `PlayerController.position` (mono timecodes), transport controls (play toggles real mock state),
  bottom action row.
- **Playlist**: collapsing 430px hero, action row + play FAB, track list (now-playing row tinted red,
  per-row like toggles, mono numbers/durations). Tapping a track → sets player + opens `/player`.

### Phase 7 — Radio, Profile, Subscription (07, 09, 10) ✅ done
- **Radio**: LIVE hero card with animated pulsing dot (`AnimationController`), popular-stations list,
  genre wrap-chips.
- **Profile**: avatar, stats, edit pill, Premium card (→ `/subscription`), playlists grid, settings list.
- **Subscription**: Monthly/Annual toggle, 3 selectable plan cards (prices switch w/ toggle,
  "MOST POPULAR" badge), perks checklist, CTA, fineprint.

### Phase 8 — Branding, polish & cross-device QA ✅
- Run `flutter_launcher_icons` + `flutter_native_splash` (paths already in pubspec snippet).
- Motion polish (`AppMotion`): button press, like heart, tab switch, page transitions.
- `SafeArea` audit across notch/home-indicator devices (we rely on real device chrome).
- Verify against the HTML reference screen-by-screen; fix spacing/typography drift.
- Smoke-test on an iOS simulator **and** an Android emulator.

---

## 5. Out of scope (this pass)
- Real audio decoding/streaming, lock-screen/background controls.
- Real authentication, accounts, persistence across launches.
- Real search results, podcasts, lyrics content, device-casting, downloads.
- Tablet/landscape layouts (design is portrait phone only).
- Light theme (intentionally dark-only).

Each of these has a clean seam (PlayerController, repositories, router) to add later.

---

## 6. Open follow-ups (not blocking)
- App store bundle id / display name confirmation (default `fm.watermelon` / "Watermelon").
- Whether to bundle font .ttf files instead of `google_fonts` before release (offline + size).
- Optional stretch: live local filtering on Search; persisting likes via `shared_preferences`.
