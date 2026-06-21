import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../core/app_logger.dart';
import '../domain/models/song.dart';
import 'repository_providers.dart';

enum DownloadPhase { downloading, done, failed }

class DownloadInfo {
  final DownloadPhase phase;
  final double progress; // 0..1
  const DownloadInfo(this.phase, [this.progress = 0]);
}

/// Whether a song already has a downloaded file on disk (from a prior session).
/// Invalidated by [DownloadManager] when a fresh download completes/deletes.
final isDownloadedProvider = FutureProvider.family<bool, String>(
  (ref, songId) => ref.watch(downloadRepositoryProvider).isDownloaded(songId),
);

/// Downloads a song's audio to local storage (YouTube via on-device extraction,
/// or a direct `audioUrl` otherwise), reporting live progress, then records it
/// in the [DownloadRepository] so playback resolves to the local file.
class DownloadManager extends Notifier<Map<String, DownloadInfo>> {
  @override
  Map<String, DownloadInfo> build() => const {};

  DownloadInfo? infoFor(String songId) => state[songId];

  void _update(String id, DownloadInfo info) =>
      state = {...state, id: info};

  Future<void> download(Song song) async {
    final id = song.id;
    if (state[id]?.phase == DownloadPhase.downloading) return;
    _update(id, const DownloadInfo(DownloadPhase.downloading, 0));
    AppLog.boot('download start', {'song': song.title});

    try {
      final dir = await _downloadsDir();
      final yt = ref.read(youtubeExplodeProvider);

      // Prefer on-device YouTube extraction (best audio-only stream w/ progress);
      // fall back to a direct audioUrl for non-YouTube catalog songs.
      final isYoutubeId = RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(id) &&
          (song.audioUrl == null || song.audioUrl!.isEmpty);

      String path;
      if (isYoutubeId) {
        final manifest = await yt.videos.streamsClient.getManifest(id);
        final audio = manifest.audioOnly;
        // Prefer AAC/M4A — iOS can't decode YouTube's Opus/WebM audio.
        final mp4 = audio.where((s) => s.container.name == 'mp4').toList();
        final info = mp4.isNotEmpty
            ? mp4.reduce((a, b) =>
                a.bitrate.bitsPerSecond >= b.bitrate.bitsPerSecond ? a : b)
            : audio.withHighestBitrate();
        path = '${dir.path}/$id.${info.container.name}';
        await _streamToFile(yt, info, File(path));
      } else {
        final url = song.audioUrl!;
        path = '${dir.path}/$id.m4a';
        await _httpToFile(url, File(path));
      }

      final size = await File(path).length();
      final res =
          await ref.read(downloadRepositoryProvider).recordDownload(song, path, size);
      if (res.isErr) throw res.errorOrNull ?? StateError('record failed');

      _update(id, const DownloadInfo(DownloadPhase.done, 1));
      ref.invalidate(isDownloadedProvider(id));
      AppLog.boot('download done', {'song': song.title, 'bytes': size});
    } catch (e, st) {
      _update(id, const DownloadInfo(DownloadPhase.failed));
      AppLog.error('boot', 'download failed', error: e, stackTrace: st);
    }
  }

  Future<void> delete(Song song) async {
    final id = song.id;
    final path = await ref.read(downloadRepositoryProvider).getDownloadPath(id);
    if (path != null) {
      final f = File(path);
      if (f.existsSync()) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }
    await ref.read(downloadRepositoryProvider).deleteDownload(id);
    state = {...state}..remove(id);
    ref.invalidate(isDownloadedProvider(id));
  }

  Future<Directory> _downloadsDir() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/downloads');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  Future<void> _streamToFile(
      YoutubeExplode yt, AudioStreamInfo info, File file) async {
    final total = info.size.totalBytes;
    final sink = file.openWrite();
    var received = 0;
    try {
      await for (final chunk in yt.videos.streamsClient.get(info)) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0) {
          _update(file.uri.pathSegments.last.split('.').first,
              DownloadInfo(DownloadPhase.downloading, received / total));
        }
      }
      await sink.flush();
    } finally {
      await sink.close();
    }
  }

  Future<void> _httpToFile(String url, File file) async {
    final client = HttpClient();
    try {
      final req = await client.getUrl(Uri.parse(url));
      final resp = await req.close();
      final total = resp.contentLength;
      final sink = file.openWrite();
      var received = 0;
      final id = file.uri.pathSegments.last.split('.').first;
      try {
        await for (final chunk in resp) {
          sink.add(chunk);
          received += chunk.length;
          if (total > 0) {
            _update(id, DownloadInfo(DownloadPhase.downloading, received / total));
          }
        }
        await sink.flush();
      } finally {
        await sink.close();
      }
    } finally {
      client.close();
    }
  }
}

final downloadManagerProvider =
    NotifierProvider<DownloadManager, Map<String, DownloadInfo>>(
        DownloadManager.new);
