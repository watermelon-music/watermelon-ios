/// A radio station from the Radio Browser directory.
/// Ported from Kotlin `domain.model.RadioStation`.
class RadioStation {
  final String? stationuuid;
  final String? name;
  final String? url;
  final String? urlResolved;
  final String? homepage;
  final String? favicon;
  final String? country;
  final String? countrycode;
  final String? language;

  /// Comma-separated tags / genres.
  final String? tags;
  final int bitrate;
  final int votes;

  const RadioStation({
    this.stationuuid,
    this.name,
    this.url,
    this.urlResolved,
    this.homepage,
    this.favicon,
    this.country,
    this.countrycode,
    this.language,
    this.tags,
    this.bitrate = 0,
    this.votes = 0,
  });

  @override
  bool operator ==(Object other) =>
      other is RadioStation && other.stationuuid == stationuuid;

  @override
  int get hashCode => stationuuid.hashCode;
}

/// A country bucket from Radio Browser (`name` + station count).
class RadioCountry {
  final String name;
  final int stationcount;
  const RadioCountry({required this.name, this.stationcount = 0});
}

/// A language bucket from Radio Browser (`name` + station count).
class RadioLanguage {
  final String name;
  final int stationcount;
  const RadioLanguage({required this.name, this.stationcount = 0});
}
