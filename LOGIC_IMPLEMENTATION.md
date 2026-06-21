# 🍉 Watermelon — Logic Implementation Guide (Kotlin → Flutter)

> **Purpose.** This document captures **all functional logic** of the original Kotlin/Jetpack-Compose
> Watermelon Android app (`~/Downloads/Watermelon-apk-main`) so it can be re-implemented in the
> Dart/Flutter app in this repo. It is a **spec**, not a UI doc — it describes data models, API
> contracts, the local database, the recommendation/autoplay engine, the playback system, and every
> business rule with its exact constants.

---

## 0. The gap — where we are vs. where the logic comes from

| | Kotlin app (source of logic) | This Flutter app (today) |
|---|---|---|
| Architecture | Modular clean arch (domain / data / feature) + Hilt DI | Single `lib/`, Riverpod, mock data |
| Data | YouTube + Audius + Jamendo + RadioBrowser + PodcastIndex + Supabase + Room | `lib/data/mock_data.dart` only |
| Audio | Real playback (Media3/ExoPlayer) + on-device extraction (NewPipe/yt-dlp) | Simulated `PlayerController` (timer) |
| Auth/sync | Supabase (GoTrue + Postgres), offline-first | Navigates to home, no real auth |
| DB | Room v8, 10 entities, analytics → recommendation engine | none |
| Recommendation | Local multi-factor scoring autoplay engine | none |

**Implication:** this is a port of a **full production backend-connected app** onto a UI-only shell.
It depends on external infrastructure (a Node backend, Supabase, several public APIs). The migration
must be **phased** (see §13), and a few decisions are required up front (see the companion questions).

---

## 1. Target architecture in Flutter

Mirror the Kotlin clean-architecture layers, idiomatic to Flutter/Riverpod:

```
lib/
├─ domain/
│  ├─ models/            # plain Dart data classes (see §2)
│  └─ repositories/      # abstract classes = repository contracts (see §3)
├─ data/
│  ├─ remote/            # API clients (dio/retrofit) per source (see §4)
│  ├─ local/             # Drift database: tables, DAOs (see §5)
│  └─ repositories/      # *Impl classes implementing domain contracts
├─ domain/autoplay/      # RecommendationEngine + scorer (pure Dart, see §6)
├─ state/                # Riverpod providers/notifiers (replaces ViewModels, see §9)
├─ services/             # playback (just_audio + audio_service), notifications
└─ screens/ + widgets/   # EXISTING UI — wire to providers, keep the design
```

### Kotlin → Dart stack mapping

| Kotlin / Android | Flutter / Dart equivalent |
|---|---|
| Hilt DI | Riverpod providers |
| Coroutines + `Flow` | `Future` + `Stream` |
| `StateFlow` / ViewModel | `Notifier` / `AsyncNotifier` (Riverpod) |
| Retrofit + OkHttp | `dio` (+ `retrofit` generator optional) |
| Room (`@Entity`/`@Dao`) | `drift` (tables + DAOs, reactive `Stream`s) |
| `SharedPreferences` | `shared_preferences` |
| Media3 / ExoPlayer | `just_audio` + `audio_service` |
| NewPipe / yt-dlp extraction | `youtube_explode_dart` (on-device) **or** backend API |
| Supabase-kt | `supabase_flutter` |
| Coil image loading | `cached_network_image` |
| Firebase Remote Config | `firebase_remote_config` **or** plain JSON endpoint |
| `Result<T>` | `Result`/`Either` (dartz) or try/catch + sealed class |
| WorkManager/AlarmManager | `workmanager` / `flutter_local_notifications` |

---

## 2. Domain models

Plain Dart classes (use `freezed` or hand-written `copyWith`/`==`). Timestamps are epoch millis (`int`).

### Song
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | required |
| `title` | `String` | required |
| `artistId` | `String` | required |
| `artistName` | `String` | required |
| `albumId` | `String?` | |
| `albumName` | `String?` | |
| `durationMs` | `int` | |
| `coverUrl` | `String?` | |
| `audioUrl` | `String?` | resolved stream URL (may be null until extracted) |
| `genre` | `String?` | |
| `releaseDate` | `String?` | |

### Playlist
`id, name, description?, coverUrl?, ownerId, songs: List<PlaylistSong>, createdAt, updatedAt, shareCode?, isPublic=false, shareCount=0, saveCount=0, copyCount=0`

**PlaylistSong:** `songId, position(int), title="", artist="", coverUrl?, audioUrl?`

### RadioStation
`stationuuid?, name?, url?, urlResolved?, homepage?, favicon?, country?, countrycode?, language?, tags?(csv), bitrate(int), votes(int)`
Helpers: `RadioCountry{name, stationcount}`, `RadioLanguage{name, stationcount}`.

### User
`id, email, username?, displayName?, avatarUrl?, plan: SubscriptionPlan(FREE|PREMIUM_INDIVIDUAL|PREMIUM_FAMILY|STUDENT)=FREE, createdAt`

### Download
`songId, filePath, fileSize(int), downloadStatus(PENDING|IN_PROGRESS|COMPLETED|FAILED|CANCELLED), progress(0–100)=0, downloadedAt`

### DownloadedSong
`songId, title, artist, coverUrl?, localFilePath, fileSize, downloadedAt`

### Album
`id, title, artistId, artistName, coverUrl?, releaseDate?, genre?, songs: List<Song>`

### Artist
`id, name, bio?, imageUrl?, genres: List<String>`

### Broadcast
`id(int), message, sender, active(bool), createdAt(String)` — in-app announcement banner.

### RemoteConfig
`maintenanceMode=false, disableYouTube=false, disableAudius=false, disableJamendo=false, freeMaxPlaylists=3`
> ⚠️ Note the **3** here is the config default; the UI enforces **2** for free users (see §11). The
> remote config value should win at runtime; hardcode 2 only as a fallback.

### SearchHistory
`query, searchedAt`

### YtDlpMetadata
`id, title, artist?, channel?, tags: List<String>, categories: List<String>, durationSec?, description?`
> Feeds the recommendation engine (tags/channel used for similarity).

---

## 3. Repository contracts (abstract classes)

Each becomes an abstract Dart class in `lib/domain/repositories/`. `Flow<T>` → `Stream<T>`,
`suspend fun(): Result<T>` → `Future<Result<T>>`.

**MusicRepository** — `getRecentlyPlayed()`, `getFavorites()`, `getTrendingMusic()`, `getRecommendedPlaylists()` → all `Stream<List<…>>`.

**MusicCatalogRepository** (external catalog, nothing stored locally) — `getTrendingMusic() → Stream<List<Song>>`, `search(query) → Stream<List<Song>>`, `getSongsByGenre(genre) → Stream<List<Song>>`.

**PlaylistRepository** — `getUserPlaylists() → Stream`, `refresh()`, `createPlaylist(name, description?, coverUrl?)`, `addSongToPlaylist(playlistId, song)`, `removeSongFromPlaylist(playlistId, songId)`, `deletePlaylist(id)`, `sharePlaylist(id) → Result<String>`, `editPlaylist(id, name, description?)`, `getPlaylistById(id) → Result<Playlist>`.

**RadioStationRepository** — `getFavoriteStations()/getRecentStations() → Stream`, `addFavorite(station)`, `removeFavorite(uuid)`, `recordRecentlyPlayed(station)`, `isFavorite(uuid) → Stream<bool>`.

**AuthRepository** — `signUp(username,email,password)`, `signIn(email,password)`, `signOut()`, `resetPassword(email)`, `resendVerificationEmail(email)`, `isEmailVerified()→bool`, `updateDisplayName/Username/Avatar`, `deleteAccount()`, `refreshUser()→User?`, `isAuthenticated()→Stream<bool>`, `getCurrentUser()→Stream<User?>`, `getCurrentUserId/Email/AccessToken()→String?`, `fetchLatestActiveBroadcast()→Broadcast?`, `checkRemoteConfig()→RemoteConfig?`.

**DownloadRepository** — `getDownloads()→Stream`, `downloadSong(song,url)`, `recordDownload(song,filePath,fileSize)`, `deleteDownload(songId)`, `cleanupMissingFiles()`, `isDownloaded(songId)→bool`, `getDownloadPath(songId)→String?`.

**UserActionsRepository** (Supabase-backed favorites/history) — `getRecentlyPlayed()/getFavorites()→Stream`, `addToFavorites(song)`, `removeFromFavorites(songId)`, `recordRecentlyPlayed(song)`.

**StreamingRepository** (playback abstraction) — `play(url,title,artist,artworkUrl)`, `pause()`, `resume()`, `stop()`, `seekTo(ms)`, `setVolume(f)`, `isPlaying()→bool`, `currentPosition()→int`, `duration()→int`, `addListener/removeListener(Callback)`.
**Callback:** `onPlaybackStateChanged(isBuffering)`, `onIsPlayingChanged(isPlaying)`, `onPositionDiscontinuity()`, `onDurationChanged(ms)`, `onPlaybackError(msg)`, `onPlaybackCompleted()`. → In Flutter, replace listener interface with `just_audio` streams.

**LyricsRepository** — `getLyrics(artist,title) → Result<String>`.

**UrlExtractorRepository** — `extractAudioUrl(sourceUrl)→Result<String>`, `extractMetadata(sourceUrl)→Result<YtDlpMetadata>`, `invalidateCache(sourceUrl)`.

---

## 4. Remote data sources

> Secrets live in `local.properties` in the Kotlin app and are injected via `BuildConfig`. In Flutter,
> use `--dart-define` / `String.fromEnvironment` or a gitignored config file. Keys needed:
> `SUPABASE_URL`, `SUPABASE_KEY`, `PODCAST_INDEX_API_KEY`, `PODCAST_INDEX_SECRET`, `JAMENDO_CLIENT_ID`,
> `WATERMELON_API_URL`.

### 4.1 Watermelon API (custom backend — primary music source)
- Base: `WATERMELON_API_URL` (default `https://watermelon-api-oxx2.onrender.com/`). Timeouts: 15s client, 60s for streaming.
- Endpoints: `GET search`, `GET getSong`, `GET getStream`, `GET getDownload`, `GET health`.
- Returns YouTube video IDs; cover = `https://i.ytimg.com/vi/{id}/maxresdefault.jpg` (fall back to `hqdefault.jpg` on 404).
- Duration parsing: `"MM:SS"` / `"HH:MM:SS"` → ms.

### 4.2 YouTube extraction (4-method fallback)
Resolve a YouTube video ID → playable audio URL, in priority order:
1. **On-device yt-dlp** (real ISP IP — bypasses datacenter blocks).
2. **Piped API** instances (`pipedapi.kavin.rocks`, …).
3. **NewPipe Extractor** (bitrate capped at **192 kbps**).
4. **Cobalt.tools** fallback.
- 10-minute URL cache (Google Video URLs expire fast). Video-ID regex: `([a-zA-Z0-9_-]{11})`.
- **Flutter port:** use `youtube_explode_dart` for on-device extraction; keep the backend `getStream` as fallback #1. (No Dart yt-dlp/NewPipe — backend covers that path.)

### 4.3 Audius (no auth)
- Trending tracks + search. Stream URL: `https://discoveryprovider.audius.co/v1/tracks/{id}/stream`.

### 4.4 Jamendo (CC music)
- Base `https://api.jamendo.com/v3.0/`. Auth: `client_id={JAMENDO_CLIENT_ID}` query param.
- `getTracks`, `searchTracks`. DTO carries `musicinfo.tags.genres`.

### 4.5 RadioBrowser (no auth)
- Base `https://all.api.radio-browser.info/`. Endpoints: `getTags`, `getCountries`, `getLanguages`, `searchStations`, `getStationsByTag`. Map DTO → `RadioStation` (see `RadioMappers`).

### 4.6 PodcastIndex (custom auth)
- Base `https://api.podcastindex.org/`. Auth header per request:
  `Authorization = SHA1(apiKey + apiSecret + epochSeconds)`, plus `X-Auth-Date = epochSeconds`, `X-Auth-Key = apiKey`.
- `searchByTerm`, `getEpisodesByFeedId`, `getRecentEpisodes`, `searchEpisodesByTerm`.

### 4.7 Lyrics — LRClib (no auth)
- Base `https://lrclib.net/`. `GET /api/search?q={artist title}` → `plainLyrics`, `syncedLyrics`.

### 4.8 Payments — Razorpay
- Base = Watermelon API. `POST /payments/create` (`userId, amount, currency="INR", plan`), `POST /payments/verify`. Signature verified server-side.

### 4.9 Supabase
- Client init from `SUPABASE_URL` + `SUPABASE_KEY`. Auth = GoTrue email/password; DB = Postgrest. Auth session exposed as a `Stream`.
- Tables: `profiles` (id, email, username, display_name, plan, avatar_url, is_banned), `playlists` (+ share_code, share_count, save_count, copy_count), `playlist_songs` (ordered by position), `favorites`, `listening_history`, `radio_favorites`.
- SQL setup lives in the Kotlin repo: `supabase_setup.sql`, `supabase_migration_playlists.sql`.

### Catalog source priority (MusicCatalogRepositoryImpl)
Search/trending resolves in order: **YouTube → Watermelon → Jamendo → Audius**, then filters out
non-music (gaming, vlogs, news, podcasts) and anything **< 45s or > 720s**.

---

## 5. Local persistence (Room v8 → Drift)

Database `watermelon.db`, **destructive migration** (drop+recreate on version bump — acceptable since
it's a cache/analytics store, the source of truth is Supabase). 10 tables:

| Table | Purpose | Key rules |
|---|---|---|
| `cached_songs` | search/trending cache | 20 rows/query, **1h TTL** |
| `user_actions` | favorites / recently-played / skips | recent capped at **50**; favorites unlimited |
| `radio_stations` | radio favorites + recent | unique `(stationUuid, actionType)` |
| `downloaded_songs` | offline MP3s | path `filesDir/downloads/{songId}.mp3` |
| `cached_playlists` / `cached_playlist_songs` | offline playlist copies | |
| `play_history` | play records (autoplay signal) | capped at **50** |
| `skips` | skipped songs (autoplay signal) | capped at **50** |
| `song_scores` | recommendation scores | |
| `song_transitions` | song→song transitions (autoplay signal) | unique `(fromSongId, toSongId)`, `count` increments |

**Reactive:** Room `Flow` queries → Drift `watch…()` `Stream`s. Use `OnConflict.replace` for caches.
No FK constraints in Room; enforce integrity in DAO/repo code.

**Offline-first sync pattern** (UserActions, Playlists, Radio favorites):
1. Write to local DB immediately with `syncedToServer = false`.
2. Fire async upsert to Supabase.
3. On success set `syncedToServer = true`.
4. On app start, re-push any rows still unsynced.
5. Local data is **not** wiped on logout (offline access); cleared only on ban/account-delete.

**Downloads** use a `Mutex` to serialize concurrent downloads; validate file exists before reporting
downloaded; `cleanupMissingFiles()` removes orphaned rows. → In Dart use a `package:synchronized` lock.

**Playlist 4-layer cache:** in-memory `StateNotifier` (UI truth) → SharedPreferences JSON (cold start)
→ Drift tables (offline browse) → Supabase (remote truth).

---

## 6. Autoplay / Recommendation engine ⭐ (the crown jewel — port verbatim)

Pure Dart, no platform deps. Two parts: **RecommendationEngine** (generates a scored queue) and the
**AutoplayRepository** (caching wrapper + analytics recording).

### 6.1 Scoring weights (RecommendationEngineImpl)
```dart
const relatedArtist        = 40.0;
const sameGenre            = 30.0;
const userHistory          = 20.0;
const randomDiscovery      = 10.0;
const hashtagSemantic      = 35.0;  // applied inline
const sameArtistBonus      = 15.0;
const favoriteArtistBonus  = 10.0;
const skipPenalty          = 50.0;  // subtracted
const recencyDecayBase     = 25.0;
const titleSimThreshold    = 0.45;  // hard filter
```
> A separate `RecommendationWeights` (transitionFreq=30, likeSkipRatio=20, skipPenalty=15,
> recencyDecay=0.5, tagSimilarity=5) exists as an interface default but is **overridden** by the
> impl above. Port the **impl** numbers.

### 6.2 `generateQueue(currentSong, excludeIds, count=20)` — 5 phases

**Phase 1 — fetch candidate pools** (dedupe by `id` into one map):
- *Related artist:* search catalog by artist name → take 15. If artist has separators (`,`/`&`/`feat.`/`ft.`/`x`), also search each sub-artist → 8 each. Drop any with `titleSimilarity > 0.45`.
- *Same genre:* `getSongsByGenre` → 15 (empty if genre blank).
- *User history:* up to 10 favorites (shuffled) + up to 5 distinct recent artists → search each → 5 each.
- *Random discovery:* trending → shuffle → 10.
- *Hashtag/semantic:* take ≤2 words from current title (len>3, excluding "song"/"video"/"lyric") → search → 10 each → filter `titleSimilarity < 0.45`.

**Phase 2 — load user signals:** favorites, skip set, recent-plays (indexed by position), favorite-artist-name set.

**Phase 3 — score each candidate:**
```
titleSim = titleSimilarity(current.title, cand.title)
if (titleSim > 0.45) DROP                       // hard filter
score = 0
if cand in artistPool   score += 40
if cand in genrePool    score += 30
if cand in historyPool  score += 20
if cand in randomPool    score += 10
if cand in hashtagPool  score += 35
if cand.artist == current.artist           score += 15
if cand.artist in favoriteArtistNames      score += 10
if cand.id in skips                        score -= 50
if cand in recentPlays:
    score -= (recentPlays.size - recentIndex)/recentPlays.size * 25   // linear recency decay
```
Score range ≈ **−50 … +160**.

**Phase 4 — diversity filter (greedy):** sort desc by score; accept songs while
`≤ 2 per artist` and `≤ 2 per album`; stop at `count`.

**Phase 5 — shuffle within tiers:** if >3 songs, chunk into groups of 3 and shuffle each group (breaks determinism without losing ranking).

### 6.3 Title similarity (port exactly)
```
normalize(t):
  remove "(...)" and "[...]"
  remove word-variants: remix|edit|extended|radio|mix|cover|live|acoustic|
                        slowed|reverb|phonk|instrumental|karaoke|version|vip|bootleg|flip
  keep only [a-z0-9]
similarity(a,b):
  na,nb = normalize(a),normalize(b)
  if na==nb -> 1.0 ; if either empty -> 0.0
  return 1.0 - levenshtein(na,nb)/max(len)
```
Standard Levenshtein (ins/del/sub cost 1). Threshold **0.45** drops near-duplicate titles.

### 6.4 AutoplayRepository (cache + analytics)
- Cache = FIFO `Queue<Song>`. `BATCH_SIZE = 20`, `REFILL_THRESHOLD = 10`.
- `findNextSong(currentSong, excludeIds)`:
  1. return null if autoplay disabled (pref `autoplay_enabled` in `watermelon_autoplay`).
  2. if `currentSong.id` changed since last call → clear cache + invalidate engine cache.
  3. excludeSet = excludeIds + currentSong.id + recentHistory ids.
  4. if `cache.size < 10` → `generateQueue(count=20)` excluding (excludeSet ∪ cache ids); append.
  5. pop from front until one not in excludeSet; return it.
- **Analytics recorded:** `recordPlayStart(song, source)` → play_history; `recordSkip(song, context)` → skips; `recordTransition(from,to)` → transitions (increment `count` if pair exists); `clearAll()` wipes all analytics + cache.

---

## 7. Playback system (PlayerViewModel + service)

### Playback state
`currentSong?, queue: List<Song>, originalQueue, currentIndex, isPlaying, isBuffering, positionMs, durationMs, repeatMode(NONE|ALL|ONE), isShuffled, sleepTimerRemainingSec?, isFavorite, lyrics?`.

### Controls
- `play(song)/togglePlayPause()/seekTo(ms)/next()/previous()`.
- **Source resolution order:** local download → `song.audioUrl` → YouTube extraction.
- **Shuffle:** shuffle queue, move current song to index 0, reset `currentIndex=0`; keep `originalQueue` to restore.
- **Repeat cycle:** NONE → ALL → ONE → NONE.
- **Sleep timer:** `remaining = minutes * 60`, decrement every 1000 ms; cancellable; pauses at 0.
- **Errors:** `MAX_CONSECUTIVE_ERRORS = 3`, 3000 ms retry delay, invalidate extraction cache on failure, then skip.
- On every song load: record play-start + fetch lyrics.
- Favorites: separate toggle paths for songs vs radio stations.

### Autoplay trigger
Keep **≥ 10** songs ahead of `currentIndex`; when running low (or queue exhausted, or manual next at end) call `AutoplayEngine.findNextSong` (via `CandidateFetcher`, which strips recent + excluded) and append.

### Flutter port
- `StreamingRepository` → wrapper around **`just_audio`** (`AudioPlayer`), exposing its `positionStream`, `playerStateStream`, `durationStream`, `processingStateStream` instead of the Kotlin listener interface.
- Background playback / lockscreen / notification controls → **`audio_service`** (replaces the Media3 `PlaybackService` + media session + Palette artwork color extraction).

---

## 8. Config, updater, notifications, navigation (infra)

### KillSwitch / RemoteConfig
- Sourced from Firebase Remote Config (300 s cache) **and** a backend check in `MainActivity`.
- Gates: `disableYouTube`, `disableAudius`, `disableJamendo`, `forceUpdate`, `freeMaxPlaylists`, `maintenanceMode`. Defaults permissive.
- **Flutter:** `firebase_remote_config`, or simpler — a `GET /config` JSON on the Watermelon API decoded into `RemoteConfig`.

### AppUpdater — *Android-only, do not port directly*
Polls GitHub releases, compares semver, downloads APK, installs via FileProvider intent. **No iOS/Flutter equivalent** (App Store / Play Store handle updates). Drop or replace with an "update available" banner.

### NotificationReceiver — daily engagement
- Random interval from `[6, 8, 12, 24]` hours, re-randomized each schedule.
- 8 title templates + 8 messages, personalized with user name; custom tone `watermelon_tone.mp3`.
- Uses AlarmManager (Doze-bypass) + boot receiver.
- **Flutter:** `flutter_local_notifications` + `workmanager` (or `android_alarm_manager_plus`); iOS uses `UNUserNotificationCenter` scheduling.

### Navigation — 18 routes; 5 bottom tabs
Tabs: **Home, Radio, Search, Library, Premium**. Routes incl. Splash, Login, Register, ForgotPassword, VerifyEmail, Home, Radio, Search, Library, Player, Queue, Downloads, PlaylistDetail, CreatePlaylist, Profile, Settings, Premium, About.
- Splash: min **600 ms**, then → Login / Home / VerifyEmail by auth state.
- Deep links: `watermelon://` (confirm, playlist) + `https://` web links.
> ⚠️ **This differs from the current Flutter app**, which has 4 tabs (Home/Search/Radio/Profile) and
> no Library/Premium tabs or Downloads/Queue/Settings routes. Reconcile during the port (see §12).

### ThemeManager
`shared_preferences` ("watermelon_settings" / "theme_mode") = `system`(default)|`light`|`dark`.
> Current Flutter app is **dark-only** by design — keep dark-only unless light theme is wanted.

---

## 9. Feature logic (ViewModels → Riverpod Notifiers)

Each Kotlin ViewModel → a Riverpod `Notifier`/`AsyncNotifier` with an immutable state class.

| Notifier | State | Key logic & constants |
|---|---|---|
| **Auth** | loading, error?, isVerified | password **min 6 chars**; email-verify required after signup; detailed error→message mapping (rate limit / network / server) |
| **Home** | trending, genreSections(8), loading | 8 genre rows, **7 songs each**; refresh daily at **05:30 IST**; add-to-playlist flow |
| **Search** | query, results, loading | **300 ms** debounce; loading-counter pattern |
| **Library** | playlists, downloads, loading | **2 free / 5 premium** playlist cap; **800 ms** artificial load delay |
| **PlaylistDetail** | playlist, isOwner | local vs remote based on ownership; import/clone shared playlist |
| **Downloads** | downloadedSongs | map file paths; cleanup missing |
| **Settings** | autoplayEnabled, theme | persist autoplay; clear cache; delete-account workflow |
| **Radio** | stations, countries, languages, favorites | **400 ms** debounce; **100** stations (country/lang) / **50** (search); sort by votes then bitrate; favorite via UUID fallback |
| **Profile** | user, editing | DiceBear avatar generation; selective field updates |
| **Premium** | plans, paymentState, studentVerified | Razorpay create→verify; student verification |

---

## 10. Business-rules & constants quick reference

| Rule | Value |
|---|---|
| Password min length | **6** |
| Free playlists | **2** (UI) / config `freeMaxPlaylists` default 3 |
| Premium playlists | **5** |
| Search debounce | **300 ms** (radio **400 ms**) |
| Library load delay | **800 ms** |
| Splash min dwell | **600 ms** |
| Home genres × songs | **8 × 7** |
| Home refresh | daily **05:30 IST** |
| Radio result caps | **100** browse / **50** search |
| Recent / history / skips cap | **50** each |
| Cached songs/query, TTL | **20**, **1 h** |
| Music duration filter | **45 s – 720 s** |
| Autoplay batch / refill | **20** / **10** |
| Diversity cap | **2 per artist**, **2 per album** |
| Title-similarity drop | **> 0.45** |
| NewPipe bitrate cap | **192 kbps** |
| Extraction URL cache | **10 min** |
| Max consecutive play errors | **3** (3 s retry) |
| Notification intervals | **6 / 8 / 12 / 24 h** |

---

## 11. Recommended Flutter packages

`dio`, `drift` (+`sqlite3_flutter_libs`), `shared_preferences`, `just_audio`, `audio_service`,
`youtube_explode_dart`, `supabase_flutter`, `cached_network_image`, `flutter_local_notifications`,
`workmanager`, `crypto` (PodcastIndex SHA-1), `path_provider` (download dir), `synchronized` (download mutex),
`flutter_riverpod` + `riverpod_generator` (already on Riverpod), optional `freezed`+`json_serializable`.

---

## 12. Reconciliation with the existing Flutter app

The current app has a designed UI and a mock `PlayerController`. Plan:
1. **Keep** the existing screens/widgets and theme (the design is good and tested).
2. **Add** the `domain/` + `data/` layers from this spec.
3. **Swap** `lib/data/mock_data.dart` reads for repository calls, screen by screen.
4. **Replace** the mock `PlayerController` with the `just_audio`/`audio_service`-backed one (§7), preserving the same public surface the UI already uses so screens barely change.
5. **Decide** tab structure: source app = 5 tabs (Home/Radio/Search/Library/Premium); current = 4 (Home/Search/Radio/Profile). Pick one before wiring nav.

---

## 13. Suggested phased migration

| Phase | Deliverable |
|---|---|
| **P0 Foundations** | domain models + repository abstractions + DI providers; config flags; package setup |
| **P1 Catalog + Search** | Watermelon API + Audius/Jamendo clients; `MusicCatalogRepository`; wire Search & Home to real data |
| **P2 Playback** | `just_audio`+`audio_service` `StreamingRepository`; YouTube extraction (backend + `youtube_explode_dart`); real player + queue + mini-player |
| **P3 Local DB** | Drift schema (10 tables); favorites/recent/downloads/play-history; offline-first |
| **P4 Auth + sync** | `supabase_flutter`; auth flow, profile, playlists CRUD + cloud sync |
| **P5 Recommendation** | port the autoplay engine (§6) verbatim + analytics recording; autoplay toggle |
| **P6 Radio** | RadioBrowser client + favorites/recent |
| **P7 Premium + extras** | Razorpay flow, lyrics (LRClib), podcasts (PodcastIndex), notifications |

Each phase ends in a runnable, testable app.

---

## 14. Explicitly out / changed for Flutter

- **AppUpdater (APK self-install)** — drop; stores handle updates.
- **Android foreground service / AlarmManager / FileProvider** — replaced by `audio_service` / `workmanager` / `path_provider`.
- **NewPipe + on-device yt-dlp** — no Dart port; rely on backend `getStream` + `youtube_explode_dart`.
- **Hilt/Compose specifics** — replaced by Riverpod/Flutter widgets.

---

*Generated from analysis of all 143 Kotlin files in `~/Downloads/Watermelon-apk-main`
(domain, data, feature-*, app, core modules).*
