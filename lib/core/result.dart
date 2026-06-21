/// A lightweight `Result` type mirroring Kotlin's `Result<T>`.
///
/// Repository methods that can fail return a [Result] instead of throwing, so
/// callers handle success/failure explicitly. Use [Unit] for "succeeded with no
/// value" (the Dart equivalent of Kotlin's `Result<Unit>`).
library;

/// Stand-in for Kotlin's `Unit` — a single valueless success payload.
class Unit {
  const Unit._();
  static const Unit unit = Unit._();
  @override
  String toString() => 'Unit';
}

/// Sealed result of an operation that may fail.
sealed class Result<T> {
  const Result();

  /// Wrap a successful [value].
  const factory Result.ok(T value) = Ok<T>;

  /// Wrap a failure with its [error] and optional [stackTrace].
  const factory Result.err(Object error, [StackTrace? stackTrace]) = Err<T>;

  /// Run [body], capturing any thrown error into an [Err].
  static Future<Result<T>> guard<T>(Future<T> Function() body) async {
    try {
      return Ok(await body());
    } catch (e, st) {
      return Err(e, st);
    }
  }

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  /// The value if successful, otherwise null.
  T? get valueOrNull => switch (this) {
        Ok(:final value) => value,
        Err() => null,
      };

  /// The error if failed, otherwise null.
  Object? get errorOrNull => switch (this) {
        Ok() => null,
        Err(:final error) => error,
      };

  /// Transform the success value.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Ok(:final value) => Ok(transform(value)),
        Err(:final error, :final stackTrace) => Err(error, stackTrace),
      };

  /// Collapse both branches into a single value.
  R fold<R>(R Function(T value) onOk, R Function(Object error) onErr) =>
      switch (this) {
        Ok(:final value) => onOk(value),
        Err(:final error) => onErr(error),
      };
}

/// Successful [Result].
final class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

/// Failed [Result].
final class Err<T> extends Result<T> {
  final Object error;
  final StackTrace? stackTrace;
  const Err(this.error, [this.stackTrace]);
}
