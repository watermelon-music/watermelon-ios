# 🍉 Watermelon (Flutter) — Progress

> Porting the Kotlin/Compose Watermelon app's logic into this Flutter app, then
> wiring it into the existing UI. Full spec: [`LOGIC_IMPLEMENTATION.md`](LOGIC_IMPLEMENTATION.md).
> Last updated: 2026-06-22.

---

## Status at a glance

| Phase | Scope | State |
|---|---|---|
| **P0** | Foundations (domain models, repo contracts, `Result`, DI seams, config) | ✅ Done |
| **P1** | Catalog + search (sources, `MusicCatalogRepository`) | ✅ Done |
| **P2** | Playback (`just_audio`, `PlaybackController`) | ✅ Core done · `audio_service` (bg/lockscreen) deferred |
| **P3** | Local DB (Drift, 10 tables, offline-first) | ✅ Done |
| **P4** | Auth + cloud (Supabase) | ✅ Core done · playlist/favorites cloud sync deferred |
| **P5** | Recommendation / autoplay engine | ✅ Done + wired into the live player |
| **P6** | Radio (RadioBrowser) | ⬜ Not started |
| **P7** | Premium / lyrics / podcasts / notifications | ⬜ Not started |

**Tests:** 58 passing (auth, autoplay, catalog, local DB, playback).

---

## What works in the running app today

- **Auth** — real Supabase sign-in / sign-up with validation + error messages; an
  auth-aware router redirect (persisted session → straight to Home; signed-out →
  onboarding); **Log out** (with confirm dialog) in Profile.
- **Real user data** — Home greeting and Profile show the Supabase `display_name`
  (`@handle` + avatar too). Home shows the first name ("Good evening, Jayash").
- **Real player** — the whole UI drives one real `PlaybackController` (queue,
  shuffle, repeat, autoplay refill, scrubber). Mini-player + Now Playing reflect
  live state.
- **YouTube** — on-device search, playback, and download (details below).
- **Smart-autoplay toggle** in Profile.

---

## 🎵 YouTube playback + search + download

The hosted Watermelon backend's yt-dlp is **broken** (`/search` → `spawn ETXTBSY`
on Render's free tier; stream endpoints 404), so playback is **fully on-device**
via [`youtube_explode_dart`](https://pub.dev/packages/youtube_explode_dart) `3.1.0`
— the Dart equivalent of yt-dlp.

**Pieces**
- `lib/data/remote/youtube/youtube_source.dart` — YouTube as the primary
  `CatalogSource` (search / trending / by-genre).
- `lib/data/remote/youtube/youtube_url_extractor.dart` — videoId → best **AAC/M4A**
  audio-only stream (prefers `mp4` container; iOS can't decode Opus/WebM), 10-min URL cache.
- `lib/state/download_manager.dart` — downloads audio to `appSupport/downloads`
  with live progress; recorded in the DB so playback then uses the local file.
- `lib/widgets/download_button.dart` — reusable control (idle → progress ring → green check).
- Search screen rewired to live YouTube search (300 ms debounce) with play + per-row download.

**iOS playback — download-then-play.** AVPlayer/just_audio can't reliably stream
`googlevideo` URLs (direct play → `"(-1) unknown error"`; a hand-rolled
`StreamAudioSource` played ~10 s then went silent while the playhead kept moving
— AVPlayer reads the moov/duration up front but the throttled stream truncates).
So YouTube tracks are now **downloaded to a temp cache, then played as a local
file** (a complete M4A plays flawlessly on AVPlayer):
1. `getManifest(id)` with the **default** client set (explicit clients → 403);
   pick the best **AAC/M4A** stream (iOS can't decode Opus/WebM).
2. Download to `tmp/yt_<id>.m4a` in **1 MiB `range=` query-param chunks** — each
   chunk request resets googlevideo's throttle (a single sequential download is
   rate-limited to ~playback speed, i.e. minutes). Chunks retry transient fails.
3. Play the local file via `AudioSource.uri`.

⚠️ **Not yet re-verified end-to-end** after the switch to download-then-play:
heavy automated testing (~25 rebuilds) tripped YouTube's **IP-level abuse
detection** (`google_abuse` / "Redirect limit exceeded" on search). That's
environmental, not a code bug — it clears after a cooldown. The download-then-play
approach itself is structurally sound (an earlier streaming build did play live).
Verify interactively once the IP cools down.

---

## Architecture

```
lib/
├─ domain/            models, repository contracts, autoplay engine (pure Dart)
├─ data/
│  ├─ remote/         catalog sources (youtube, audius, jamendo), supabase, youtube extractor
│  ├─ local/          Drift database (app_database.dart)
│  └─ repositories/   *Impl classes (auth, catalog, downloads, streaming, radio, …)
├─ state/             Riverpod providers + controllers (playback, download, repository_providers)
├─ screens/ + widgets/  existing designed UI, wired to providers
└─ config/ + core/    app config (.env), Result, logger
```

- **DI:** Riverpod (`lib/state/repository_providers.dart`).
- **Catalog source priority:** YouTube → Audius → Jamendo.
- **Logging:** `lib/core/app_logger.dart` (`AppLog.auth/boot/nav/error`, 🍉-tagged, debug-only).

---

## Config / secrets

Keys live in a gitignored **`.env`** (loaded via `flutter_dotenv`; `.env.example`
is the template). Supabase URL + anon key, Jamendo client id, etc. See
[`api keys note in memory`]. `youtube_explode_dart` needs no keys.

---

## Known caveats / next up

- **Home "New releases"** still shows Audius, not YouTube — the YouTube trending
  query returns long compilations that the 45–720 s music filter drops, so it
  falls through (plus a 1 h trending cache). Search is the real YouTube surface.
- **Mock data still in:** Home jump-back tiles (no tap), Profile stats/playlists,
  Radio stations, Search "Browse all" categories.
- **YouTube extraction is inherently fragile** — YouTube changes break it; the
  fix is bumping `youtube_explode_dart`.
- **Deferred:** `audio_service` (background/lockscreen), playlist + favorites
  cloud sync (P4.5), Radio (P6), Premium/lyrics/podcasts (P7), forgot-password +
  social sign-in buttons.
- **iOS build pin:** `device_info_plus` pinned to `12.3.0` (13.x calls a
  selector that needs the iOS 26.1 SDK / Xcode 26; breaks on Xcode 16). Drop the
  override when on Xcode 26.
