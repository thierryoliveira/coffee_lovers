import 'package:equatable/equatable.dart';

/// Base class for all failure types in the application.
abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}
