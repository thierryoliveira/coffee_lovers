import 'package:very_good_ventures_test/core/either/either.dart';
import 'package:very_good_ventures_test/core/errors/failures/failure.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/entities/coffee_image_entity.dart';

/// Repository interface for coffee image related operations.
abstract interface class CoffeeImageRepository {
  Future<Either<Failure, String>> getRandomCoffeeImage();
  Future<Either<Failure, List<CoffeeImageEntity>>> saveFavorite(String url);
  Future<Either<Failure, List<CoffeeImageEntity>>> getFavorites();
  Future<Either<Failure, List<CoffeeImageEntity>>> removeFavorite(String url);
}
