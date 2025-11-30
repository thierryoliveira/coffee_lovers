import 'package:very_good_ventures_test/features/coffee_image/data/models/coffee_image_model.dart';

abstract interface class CoffeeImageDataSource {
  /// Fetches a random coffee image URL
  Future<CoffeeImageModel> getRandomCoffeeImage();
}
