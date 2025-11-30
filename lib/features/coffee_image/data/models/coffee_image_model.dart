import 'package:equatable/equatable.dart';

final class CoffeeImageModel extends Equatable {
  /// The coffee image file URL
  final String file;

  const CoffeeImageModel({required this.file});

  @override
  List<Object?> get props => [file];
}
