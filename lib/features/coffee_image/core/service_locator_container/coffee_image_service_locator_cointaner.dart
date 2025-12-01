import 'package:http/http.dart';
import 'package:very_good_ventures_test/core/local_storage/local_storage.dart';
import 'package:very_good_ventures_test/core/service_locator/service_locator_container.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/local/coffee_image_local_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/local/coffee_image_local_datasource_impl.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/remote/coffee_image_remote_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/remote/coffee_image_remote_datasource_impl.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/repositories/coffee_image_repository_impl.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/repositories/coffee_image_repository.dart';

final class CoffeeImageServiceLocatorCointaner extends ServiceLocatorContainer {
  @override
  void register() {
    // DataSources
    serviceLocator.sl
      ..registerFactory<CoffeeImageRemoteDataSource>(
        () => CoffeeImageRemoteDataSourceImpl(client: Client()),
      )
      ..registerFactory<CoffeeImageLocalDataSource>(
        () => CoffeeImageLocalDataSourceImpl(
          favoritesBox: LocalStorage().favoritesBox,
        ),
      );

    // Repositories
    serviceLocator.sl.registerFactory<CoffeeImageRepository>(
      () => CoffeeImageRepositoryImpl(
        remoteDataSource: serviceLocator.sl<CoffeeImageRemoteDataSource>(),
        localDataSource: serviceLocator.sl<CoffeeImageLocalDataSource>(),
      ),
    );
  }
}
