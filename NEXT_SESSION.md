# Watermelon — next session

Flutter music app from `~/Downloads/watermelon-design`. See `IMPLEMENTATION_PLAN.md`.
Stack: Riverpod 3 (Notifier), go_router, google_fonts, flutter_svg. Mock player (no real audio). Dark-only.

## Done: Phases 1–7
- Theme/assets, models, mock data, Riverpod state (player/likes/subscription).
- Shells + components (MiniPlayer, TabBar, TrackTile, etc.).
- Screens: Onboarding, Login, Register, Home, Search, Now Playing, Playlist,
  Radio (LIVE hero w/ pulsing dot, stations, genre chips), Profile (avatar/stats/
  Premium card/playlists/settings), Subscription (billing toggle, plan cards, perks).

## TODO: Phase 8 — branding/launcher/splash, motion polish, cross-device QA.

## Verify each phase
`flutter analyze` · `flutter test` (12 passing) · `flutter build ios --simulator --debug`

## Notes
- Enum is `LoopMode` (material already exports `RepeatMode`).
- Tab screens use bottom inset 158 to clear mini-player + tab bar.
- `stub_screen.dart` removed — all 10 screens are now real.
- Radio/station play buttons start the mock queue + open `/player` (mock app).
