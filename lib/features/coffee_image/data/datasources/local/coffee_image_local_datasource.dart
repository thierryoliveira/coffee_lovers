import 'package:very_good_ventures_test/features/coffee_image/data/models/coffee_image_model.dart';

abstract interface class CoffeeImageLocalDataSource {
  Future<void> saveFavorite(String url);
  Future<List<CoffeeImageModel>> getFavoriteUrls();
  Future<void> removeFavorite(String url);
}
