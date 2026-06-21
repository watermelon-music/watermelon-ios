/// A song available offline. Ported from Kotlin `domain.model.DownloadedSong`.
class DownloadedSong {
  final String songId;
  final String title;
  final String artist;
  final String? coverUrl;
  final String localFilePath;
  final int fileSize;
  final int downloadedAt;

  const DownloadedSong({
    required this.songId,
    required this.title,
    required this.artist,
    this.coverUrl,
    required this.localFilePath,
    this.fileSize = 0,
    required this.downloadedAt,
  });

  @override
  bool operator ==(Object other) =>
      other is DownloadedSong && other.songId == songId;

  @override
  int get hashCode => songId.hashCode;
}
