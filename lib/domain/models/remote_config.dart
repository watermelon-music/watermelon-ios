/// Server-controlled feature flags / kill switches.
/// Ported from Kotlin `domain.model.RemoteConfig`.
class RemoteConfig {
  final bool maintenanceMode;
  final bool disableYouTube;
  final bool disableAudius;
  final bool disableJamendo;

  /// Max playlists for free users (server-overridable; UI fallback is 2).
  final int freeMaxPlaylists;

  const RemoteConfig({
    this.maintenanceMode = false,
    this.disableYouTube = false,
    this.disableAudius = false,
    this.disableJamendo = false,
    this.freeMaxPlaylists = 3,
  });
}
