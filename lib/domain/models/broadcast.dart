/// An in-app announcement banner. Ported from Kotlin `domain.model.Broadcast`.
class Broadcast {
  final int id;
  final String message;
  final String sender;
  final bool active;
  final String createdAt;

  const Broadcast({
    required this.id,
    required this.message,
    required this.sender,
    required this.active,
    required this.createdAt,
  });
}
