import 'package:very_good_ventures_test/features/coffee_image/domain/entities/coffee_image_entity.dart';

final class CoffeeImageModel extends CoffeeImageEntity {
  const CoffeeImageModel({required super.file});

  factory CoffeeImageModel.fromJson(Map<String, dynamic> json) {
    return CoffeeImageModel(file: json['file']);
  }

  CoffeeImageEntity toEntity() {
    return CoffeeImageEntity(file: file);
  }
}
