/// Formats a [Duration] as `m:ss` (e.g. 3:42) — used for timecodes/durations,
/// which the design renders in JetBrains Mono.
String formatDuration(Duration d) {
  final minutes = d.inMinutes;
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Formats remaining time as `-m:ss` (used on the now-playing scrubber).
String formatRemaining(Duration total, Duration position) {
  final remaining = total - position;
  return '-${formatDuration(remaining.isNegative ? Duration.zero : remaining)}';
}

/// Parses a `m:ss` label into a [Duration].
Duration parseDuration(String label) {
  final parts = label.split(':');
  if (parts.length != 2) return Duration.zero;
  final minutes = int.tryParse(parts[0]) ?? 0;
  final seconds = int.tryParse(parts[1]) ?? 0;
  return Duration(minutes: minutes, seconds: seconds);
}
