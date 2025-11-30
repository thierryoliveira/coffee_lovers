import 'package:very_good_ventures_test/core/errors/failures/failure.dart';

/// A [Failure] representing a server-side error.
final class ServerFailure extends Failure {
  final String message;

  ServerFailure({required this.message});

  @override
  String toString() => 'ServerFailure: $message';

  @override
  List<Object?> get props => [message];
}
