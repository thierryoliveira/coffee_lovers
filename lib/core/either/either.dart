import 'package:equatable/equatable.dart';

/// An implementation of the Either type to represent values with two possibilities.
abstract class Either<L, R> extends Equatable {
  const Either();

  /// Applies one of the provided functions based on whether the instance is Left or Right.
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);

  @override
  List<Object?> get props => [];
}

/// Represents the left value of an Either type.
class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) =>
      onLeft(value);

  @override
  List<Object?> get props => [value];
}

/// Represents the right value of an Either type.
class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) =>
      onRight(value);

  @override
  List<Object?> get props => [value];
}

extension EitherUtils<L, R> on Either<L, R> {
  /// Whether the instance is a Left value.
  bool get isLeft => this is Left<L, R>;

  /// Whether the instance is a Right value.
  bool get isRight => this is Right<L, R>;
}
