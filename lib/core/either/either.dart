/// An implementation of the Either type to represent values with two possibilities.
abstract class Either<L, R> {
  const Either();

  /// Applies one of the provided functions based on whether the instance is Left or Right.
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);
}

/// Represents the left value of an Either type.
class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) =>
      onLeft(value);
}

/// Represents the right value of an Either type.
class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) =>
      onRight(value);
}

extension EitherUtils<L, R> on Either<L, R> {
  /// Whether the instance is a Left value.
  bool get isLeft => this is Left<L, R>;

  /// Whether the instance is a Right value.
  bool get isRight => this is Right<L, R>;
}
