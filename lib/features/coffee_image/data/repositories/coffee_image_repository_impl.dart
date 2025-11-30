import 'package:very_good_ventures_test/core/either/either.dart';
import 'package:very_good_ventures_test/core/errors/exceptions/server_exception.dart';
import 'package:very_good_ventures_test/core/errors/failures/failure.dart';
import 'package:very_good_ventures_test/core/errors/failures/server_failure.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/coffee_image_remote_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/entities/coffee_image_entity.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/repositories/coffee_image_repository.dart';

class CoffeeImageRepositoryImpl implements CoffeeImageRepository {
  final CoffeeImageRemoteDataSource _remoteDataSource;

  CoffeeImageRepositoryImpl({
    required CoffeeImageRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

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
}
