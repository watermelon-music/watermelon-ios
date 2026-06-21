/// A radio station (Radio screen).
class Station {
  final String name;
  final String genre;
  final String listeners; // e.g. "4.2k"
  final String art;

  const Station({
    required this.name,
    required this.genre,
    required this.listeners,
    required this.art,
  });
}
