/// Lifecycle of a download. Ported from Kotlin `DownloadStatus`.
enum DownloadStatus { pending, inProgress, completed, failed, cancelled }

/// An in-flight or completed download record.
/// Ported from Kotlin `domain.model.Download`.
class Download {
  final String songId;
  final String filePath;
  final int fileSize;
  final DownloadStatus downloadStatus;

  /// 0–100.
  final int progress;
  final int downloadedAt;

  const Download({
    required this.songId,
    required this.filePath,
    this.fileSize = 0,
    required this.downloadStatus,
    this.progress = 0,
    required this.downloadedAt,
  });

  Download copyWith({
    String? songId,
    String? filePath,
    int? fileSize,
    DownloadStatus? downloadStatus,
    int? progress,
    int? downloadedAt,
  }) {
    return Download(
      songId: songId ?? this.songId,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      progress: progress ?? this.progress,
      downloadedAt: downloadedAt ?? this.downloadedAt,
    );
  }
}
