import 'package:equatable/equatable.dart';

class CoffeeImageEntity extends Equatable {
  final String? file;

  const CoffeeImageEntity({required this.file});

  @override
  List<Object?> get props => [file];
}
