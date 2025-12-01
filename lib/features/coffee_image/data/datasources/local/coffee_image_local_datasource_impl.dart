import 'package:hive/hive.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/local/coffee_image_local_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/models/coffee_image_model.dart';

class CoffeeImageLocalDataSourceImpl implements CoffeeImageLocalDataSource {
  final Box favoritesBox;

  CoffeeImageLocalDataSourceImpl({required this.favoritesBox});

  @override
  Future<void> saveFavorite(String url) async {
    await favoritesBox.add(url);
  }

  @override
  Future<List<CoffeeImageModel>> getFavoriteUrls() async {
    return favoritesBox.values
        .map((url) => CoffeeImageModel(file: url))
        .toList();
  }

  @override
  Future<void> removeFavorite(String url) async {
    final index = favoritesBox.values.toList().indexOf(url);
    if (index != -1) {
      await favoritesBox.deleteAt(index);
    }
  }
}
