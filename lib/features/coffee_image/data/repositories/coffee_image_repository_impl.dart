import 'package:very_good_ventures_test/core/either/either.dart';
import 'package:very_good_ventures_test/core/errors/exceptions/server_exception.dart';
import 'package:very_good_ventures_test/core/errors/failures/failure.dart';
import 'package:very_good_ventures_test/core/errors/failures/local_storage_failure.dart';
import 'package:very_good_ventures_test/core/errors/failures/server_failure.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/coffee_image_remote_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/local/coffee_image_local_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/entities/coffee_image_entity.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/repositories/coffee_image_repository.dart';

class CoffeeImageRepositoryImpl implements CoffeeImageRepository {
  final CoffeeImageRemoteDataSource _remoteDataSource;
  final CoffeeImageLocalDataSource _localDataSource;

  CoffeeImageRepositoryImpl({
    required CoffeeImageRemoteDataSource remoteDataSource,
    required CoffeeImageLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, CoffeeImageEntity>> getRandomCoffeeImage() async {
    try {
      final model = await _remoteDataSource.getRandomCoffeeImage();
      return Right(model.toEntity());
    } catch (exception) {
      // in case of multiple other exceptions, we could add
      // more specific handling here, using "on" blocks for each type
      final message = exception is ServerException
          ? exception.message
          : exception.toString();
      return Left(ServerFailure(message: message));
    }
  }

  @override
  Future<Either<Failure, void>> saveFavorite(String url) async {
    try {
      await _localDataSource.saveFavorite(url);
      return const Right(null);
    } catch (exception) {
      return const Left(
        LocalStorageFailure(
          message:
              'Something went wrong trying to add an image to the favorites.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CoffeeImageEntity>>> getFavorites() async {
    try {
      final models = await _localDataSource.getFavoriteUrls();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (exception) {
      return const Left(
        LocalStorageFailure(
          message: 'Something went wrong trying to get all favorited images',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String url) async {
    try {
      await _localDataSource.removeFavorite(url);
      return const Right(null);
    } catch (exception) {
      return const Left(
        LocalStorageFailure(
          message:
              'Something went wrong trying to remove an item from favorites',
        ),
      );
    }
  }
}
