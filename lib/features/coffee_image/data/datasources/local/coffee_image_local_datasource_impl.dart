import 'package:hive/hive.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/local/coffee_image_local_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/models/coffee_image_model.dart';

class CoffeeImageLocalDataSourceImpl implements CoffeeImageLocalDataSource {
  static const String favoritesBox = 'favorites';
  @override
  Future<void> saveFavorite(String url) async {
    final box = await Hive.openBox<String>(favoritesBox);
    await box.add(url);
  }

  @override
  Future<List<CoffeeImageModel>> getFavoriteUrls() async {
    final box = await Hive.openBox<String>(favoritesBox);
    return box.values.map((url) => CoffeeImageModel(file: url)).toList();
  }

  @override
  Future<void> removeFavorite(String url) async {
    final box = await Hive.openBox<String>(favoritesBox);
    return box.delete(url);
  }
}
