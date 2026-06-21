import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/plan.dart';
import '../models/playlist.dart';
import '../models/station.dart';
import '../models/track.dart';
import '../theme/app_assets.dart';

/// All sample content for the app — lifted verbatim from the design reference
/// (`Watermelon Music App.dc.html` → `renderVals()`). This is the single mock
/// "backend"; screens read from here (later, behind repositories).
class MockData {
  MockData._();

  // Artwork aliases — mirror the design's `A.*` shorthand.
  static const String _sandy = AppAssets.bgSandy;
  static const String _river = AppAssets.bgRiver;
  static const String _field = AppAssets.bgFieldTall;
  static const String _melon = AppAssets.melonWhole;
  static const String _slice = AppAssets.sliceFlat;

  static const String userName = 'Avery';
  static const String userFullName = 'Avery Melon';
  static const String userHandle = '@averymelon';

  /// The "Sunday Slice" playlist (screen 08) — also the now-playing source.
  static const List<Track> sundaySliceTracks = [
    Track(id: 't1', title: 'Seedless Summer', artist: 'Rind & Vine', art: _sandy, duration: Duration(minutes: 3, seconds: 42)),
    Track(id: 't2', title: 'Cold Press', artist: 'Juno Pith', art: _river, duration: Duration(minutes: 2, seconds: 58)),
    Track(id: 't3', title: 'First Bite', artist: 'Mara Lune', art: _field, duration: Duration(minutes: 4, seconds: 11)),
    Track(id: 't4', title: 'Saltwater Rind', artist: 'The Husk', art: _melon, duration: Duration(minutes: 3, seconds: 20)),
    Track(id: 't5', title: 'Greenhouse', artist: 'Vega Sour', art: _sandy, duration: Duration(minutes: 3, seconds: 55)),
    Track(id: 't6', title: 'Pip Pop', artist: 'Coco Melo', art: _river, duration: Duration(minutes: 2, seconds: 47)),
    Track(id: 't7', title: 'Afterglow', artist: 'Mara Lune', art: _field, duration: Duration(minutes: 5, seconds: 2)),
  ];

  static const Playlist sundaySlice = Playlist(
    id: 'sunday-slice',
    title: 'Sunday Slice',
    description: 'Slow-burning summer cuts for lazy mornings and long afternoons.',
    cover: _field,
    owner: 'Watermelon',
    ownerAvatar: _melon,
    saves: 1204,
    totalDuration: '2h 14m',
    tracks: sundaySliceTracks,
  );

  /// Default now-playing track (matches Now Playing screen 06).
  static Track get nowPlayingDefault => sundaySliceTracks.first; // Seedless Summer

  // ── Home ──────────────────────────────────────────────────────────────
  static const List<PlaylistRef> jumpBack = [
    PlaylistRef(title: 'Sunday Slice', art: _field),
    PlaylistRef(title: 'Seedless Nights', art: _sandy),
    PlaylistRef(title: 'Riverside Rinds', art: _river),
    PlaylistRef(title: 'Melon Mood', art: _melon),
    PlaylistRef(title: 'Pip Pop Hits', art: _sandy),
    PlaylistRef(title: 'Green Room', art: _river),
  ];

  static const List<Track> newReleases = [
    Track(id: 'n1', title: 'Cold Press', artist: 'Juno Pith', art: _sandy, duration: Duration(minutes: 2, seconds: 58)),
    Track(id: 'n2', title: 'Greenhouse', artist: 'Vega Sour', art: _river, duration: Duration(minutes: 3, seconds: 55)),
    Track(id: 'n3', title: 'First Bite', artist: 'Mara Lune', art: _field, duration: Duration(minutes: 4, seconds: 11)),
    Track(id: 'n4', title: 'Saltwater', artist: 'The Husk', art: _melon, duration: Duration(minutes: 3, seconds: 20)),
  ];

  // ── Search ────────────────────────────────────────────────────────────
  static const List<PlaylistRef> recents = [
    PlaylistRef(title: 'Rind & Vine', art: _sandy, subtitle: 'Artist'),
    PlaylistRef(title: 'Sunday Slice', art: _field, subtitle: 'Playlist · Watermelon'),
    PlaylistRef(title: 'Mara Lune', art: _melon, subtitle: 'Artist'),
  ];

  static const List<Category> categories = [
    Category(label: 'Summer Hits', color: Color(0xFFB3122A), image: _sandy),
    Category(label: 'Chill', color: Color(0xFF1F6B32), image: _river),
    Category(label: 'Focus', color: Color(0xFF16544A), image: _field),
    Category(label: 'Workout', color: Color(0xFFFF1A1A), image: _melon),
    Category(label: 'Fresh Finds', color: Color(0xFF3D7A2E), image: _slice),
    Category(label: 'Live Radio', color: Color(0xFF7A1020), image: _river),
  ];

  // ── Radio ─────────────────────────────────────────────────────────────
  static const List<Station> stations = [
    Station(name: 'Seedless Beats', genre: 'Electronic', listeners: '4.2k', art: _sandy),
    Station(name: 'Rind Sessions', genre: 'Lo-fi', listeners: '8.9k', art: _field),
    Station(name: 'Pith & Soul', genre: 'Soul · R&B', listeners: '3.1k', art: _melon),
    Station(name: 'Green Room', genre: 'Indie', listeners: '5.7k', art: _river),
  ];

  static const List<String> genres = [
    'Pop', 'Lo-fi', 'Jazz', 'Indie', 'Hip-hop', 'Classical', 'House', 'Acoustic',
  ];

  // ── Profile ───────────────────────────────────────────────────────────
  static const int followers = 248;
  static const int following = 182;
  static const int playlistCount = 14;

  static const List<PlaylistRef> myPlaylists = [
    PlaylistRef(title: 'Sunday Slice', art: _field, subtitle: '24 songs'),
    PlaylistRef(title: 'Late Pulp', art: _sandy, subtitle: '18 songs'),
    PlaylistRef(title: 'Rind Radio', art: _river, subtitle: '40 songs'),
    PlaylistRef(title: 'Seed Vault', art: _melon, subtitle: '12 songs'),
  ];

  static const List<String> settingsRows = [
    'Account', 'Playback', 'Audio quality', 'Notifications', 'Privacy & data',
  ];

  // ── Subscription ──────────────────────────────────────────────────────
  static const List<Plan> plans = [
    Plan(id: 'individual', name: 'Individual', subtitle: '1 Premium account', monthlyPrice: r'$9.99', annualPrice: r'$95.90', featured: true),
    Plan(id: 'family', name: 'Family', subtitle: 'Up to 6 accounts', monthlyPrice: r'$14.99', annualPrice: r'$143.90'),
    Plan(id: 'student', name: 'Student', subtitle: 'Verified students', monthlyPrice: r'$4.99', annualPrice: r'$47.90'),
  ];

  static const List<String> perks = [
    'Zero ads, ever',
    'Download to listen offline',
    'Lossless hi-fi audio',
    'Unlimited skips & on-demand play',
  ];

  /// Liked by default in the design: tracks t1 & t3, and the Sunday Slice
  /// playlist itself (the playlist heart shows filled). Playlist-level likes use
  /// a `playlist:<id>` key so they don't collide with track ids.
  static const Set<String> defaultLikedTrackIds = {'t1', 't3', 'playlist:sunday-slice'};

  /// Looks up a playlist by id. Only Sunday Slice exists in the mock, so it is
  /// the fallback for any id.
  static Playlist playlistById(String id) => sundaySlice;
}
