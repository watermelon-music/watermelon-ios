<div align="center">

<img src="assets/branding/app_icon_512.png" alt="Watermelon app icon" width="120" height="120" style="border-radius: 26px;" />

# 🍉 Watermelon

**Feel the juice.** A dark-first music-streaming app built in Flutter.

<img src="assets/images/logo-slice.png" alt="Watermelon wordmark" width="280" />

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State](https://img.shields.io/badge/State-Riverpod-44C8F5)](https://riverpod.dev)
[![Routing](https://img.shields.io/badge/Routing-go__router-0B6E4F)](https://pub.dev/packages/go_router)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-555)](#-download--install)
[![License](https://img.shields.io/badge/License-Private-FF1A1A)](#-license)

</div>

---

## Overview

Watermelon is a fully-designed, **10-screen** music-streaming experience — onboarding, auth, home, search, radio, a full-screen now-playing player, playlists, profile, and subscription. It's built from the **Watermelon Dark** design handoff and faithfully matches the pixel reference.

It runs on **iOS, Android, macOS, Windows, Linux and Web** from one codebase. On wide windows the shell adapts to an **Apple-Music-style desktop layout** — a left sidebar + a persistent bottom transport bar — while phones keep the tab-bar + mini-player.

The backend is **real**: live music search & streaming (YouTube via `youtube_explode_dart`, plus Jamendo/Audius) with a ported autoplay/recommendation engine, on-device playback (`just_audio`, and `media_kit` on Windows/Linux), Supabase auth, and a local Drift database. Content still falls back to sample data behind repository seams where a source isn't wired.

> **Design philosophy** — Dark only. Red (`#FF1A1A`) is precious: exactly one red action per view. Mono font for every number. 44px minimum tap targets.

---

## 📦 Download & install

Grab the latest build from the [**Releases**](https://github.com/watermelon-music/watermelon-ios/releases) page, or use the one-line installers below (they fetch the latest release asset for your platform automatically).

**macOS / Linux**
```sh
curl -fsSL https://raw.githubusercontent.com/watermelon-music/watermelon-ios/main/install.sh | sh
```
Installs to `/Applications/Watermelon.app` (macOS) or `/opt/watermelon` with a `watermelon` symlink + desktop entry (Linux). Uses `sudo`.

**Windows** (PowerShell)
```powershell
irm https://raw.githubusercontent.com/watermelon-music/watermelon-ios/main/install.ps1 | iex
```
Installs to `%LOCALAPPDATA%\Programs\Watermelon` and adds a Start Menu shortcut.

### Release assets

| Platform | Asset | Install |
|---|---|---|
| macOS | `watermelon-<ver>-macos-{universal,arm64,x64}.dmg` | open the DMG → drag to Applications |
| Windows | `watermelon-<ver>-windows-x64.zip` | unzip → run `watermelon.exe` |
| Linux | `watermelon-<ver>-linux-x64.tar.gz` | extract → run `watermelon` |
| Android | `watermelon-<ver>-android.apk` | install the APK directly |
| iOS | `watermelon-<ver>-ios-unsigned.zip` | unsigned `.app` — sideload (AltStore/Sideloadly) |
| Web | `watermelon-<ver>-web.zip` | serve over HTTP (e.g. `python3 -m http.server`) |

> ⚠️ Desktop/mobile builds are **not code-signed / notarized**. On macOS the installer clears the quarantine flag; if you download the DMG manually, run `xattr -dr com.apple.quarantine /Applications/Watermelon.app` or right-click → Open. The Android APK is debug-signed; the iOS build is unsigned (no `.ipa`).

Releases are produced by the [`release` GitHub Actions workflow](.github/workflows/release.yml) — *Actions → Release → Run workflow* builds all six platforms and publishes them, tagged from the `version:` in `pubspec.yaml`.

---

## ✨ Features

| Screen | Route | Highlights |
|---|---|---|
| 🚀 **Onboarding** | `/onboarding` | Full-bleed hero, gradient display type, page dots |
| 🔐 **Login** | `/login` | Email/password fields, Apple + Google buttons |
| 📝 **Register** | `/register` | Live password-strength meter, terms checkbox |
| 🏠 **Home** | `/home` | Greeting header, filter chips, "jump back in" grid, feature card |
| 🔍 **Search** | `/search` | Recent searches, colored "browse all" category tiles |
| ▶️ **Now Playing** | `/player` | Wine→black gradient, scrubber, full transport controls |
| 📻 **Radio** | `/radio` | Animated **LIVE** hero, popular stations, genre chips |
| 🎵 **Playlist** | `/playlist/:id` | Collapsing 430px hero, tinted now-playing row, per-track likes |
| 👤 **Profile** | `/profile` | Stats, Premium card, playlists grid, settings list |
| 💎 **Subscription** | `/subscription` | Monthly/Annual toggle, selectable plan cards, perks |

Persistent chrome adapts to the window size:

- **Phone** — frosted **Mini Player** (tap to open Now Playing) above a **Tab Bar** (Home / Search / Radio / Profile, red active state, custom SVG icons).
- **Desktop / wide** — a left **sidebar** (nav + Your Library) and a full-width **transport bar** with scrubber and volume.

---

## 🎨 Design system

The look is defined entirely by design tokens in `lib/theme/`:

| Token | Value |
|---|---|
| Brand red (primary) | `#FF1A1A` |
| Accent orange | `#FF6A3D` |
| App background | `#050505` |
| Surfaces | `#0C0C0D` / `#1A1A1A` |
| Player gradient | deep wine → near-black |
| Type | **Inter** (UI) + **JetBrains Mono** (all numbers) via `google_fonts` |

<div align="center">
<img src="assets/images/bg-river.png" alt="Watermelon texture" width="600" />
</div>

---

## 🛠 Tech stack

- **Flutter** 3.44 / **Dart** 3.12 — one codebase, six platforms
- **flutter_riverpod** — playback, likes & subscription state
- **go_router** — auth → adaptive shell → modal navigation
- **just_audio** (+ **just_audio_media_kit** / libmpv on Windows & Linux) — playback
- **youtube_explode_dart** — on-device search + audio extraction; Jamendo/Audius sources via **dio**
- **supabase_flutter** — auth & profiles
- **drift** + **drift_flutter** — local database (ships `sqlite3.wasm` for Web)
- **google_fonts** (Inter + JetBrains Mono) · **flutter_svg** (custom icons) · **path_provider**
- **flutter_launcher_icons** + **flutter_native_splash** — branding

---

## 📁 Project structure

```
lib/
├─ main.dart            # ProviderScope + MaterialApp.router + AppTheme.dark
├─ router.dart          # go_router: auth flow → adaptive shell → modal routes
├─ config/              # AppConfig (--dart-define / .env) + business constants
├─ theme/               # design tokens (colors, type, spacing, breakpoints, assets)
├─ domain/              # models, repository contracts, autoplay/recommendation engine
├─ data/                # remote sources (youtube/jamendo/audius/supabase), Drift DB, repo impls, mock_data
├─ state/               # Riverpod: playback_controller, providers, likes, subscription
├─ widgets/             # reusable components (mini_player, desktop/, tiles…)
└─ screens/             # the screens, grouped by feature (incl. shell/ desktop_shell)
```

---

## 🚀 Getting started

### Prerequisites
- Flutter **3.44+** ([install guide](https://docs.flutter.dev/get-started/install))
- Per target: Xcode (iOS/macOS), Android Studio (Android), Visual Studio + "Desktop development with C++" (Windows), or `clang cmake ninja-build libgtk-3-dev libmpv-dev` (Linux)

### Configuration (API keys)

Backend keys live in a gitignored **`.env`** file (loaded at runtime via `flutter_dotenv`). Copy the template and fill in your values:

```bash
cp .env.example .env   # .env is gitignored
```

Keys: `SUPABASE_URL`, `SUPABASE_KEY` (anon), `JAMENDO_CLIENT_ID`, `PODCAST_INDEX_API_KEY`, `PODCAST_INDEX_SECRET`, `WATERMELON_API_URL`. Never put a Supabase **service** key in the app. (A compile-time `--dart-define` of the same names also works as a fallback.)

### Run

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (Drift database)
dart run build_runner build

# 3. (Optional) regenerate launcher icons & splash
dart run flutter_launcher_icons
dart run flutter_native_splash:create

# 4. Launch (reads .env automatically) — pick a target
flutter run                  # default device
flutter run -d macos         # or: windows · linux · chrome (web)
```

### Build a release locally

```bash
flutter build macos --release     # → build/macos/Build/Products/Release/Watermelon.app
flutter build windows --release   # → build/windows/x64/runner/Release/
flutter build linux --release     # → build/linux/x64/release/bundle/
flutter build apk --release       # → build/app/outputs/flutter-apk/app-release.apk
flutter build web --release       # → build/web/  (serve over HTTP)
```

> All platforms are built & published automatically by CI — see [Download & install](#-download--install).

### Verify

```bash
flutter analyze   # static analysis — should report no issues
flutter test      # widget + state tests
```

---

## 🧭 Roadmap

Done, and what's left behind the same clean seams:

- [x] Real audio playback (`just_audio` / `media_kit`) + autoplay engine
- [x] Real catalog & live search (YouTube / Jamendo / Audius)
- [x] Supabase auth + local Drift database
- [x] Desktop & Web platforms with an adaptive Apple-Music-style shell
- [ ] Cloud sync for playlists & favorites (offline-first push)
- [ ] Lock-screen / background playback controls (`audio_service`)
- [ ] Live radio (RadioBrowser), lyrics & podcasts

---

## 👤 Author

<img src="https://avatars.githubusercontent.com/u/70916302" alt="Jayash Bhandary" width="100" height="100" style="border-radius: 50%;" />

**Jayash Bhandary**

[![GitHub](https://img.shields.io/badge/GitHub-JayashBhandary-181717?logo=github&logoColor=white)](https://github.com/JayashBhandary)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Jayash%20Bhandary-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jayashbhandary/)

---

## 📄 License

Private project — not currently licensed for redistribution.

<div align="center">
<sub>Built with Flutter 🍉 by <a href="https://github.com/JayashBhandary">Jayash Bhandary</a></sub>
</div>
