import 'package:get_it/get_it.dart';
import 'package:very_good_ventures_test/features/coffee_image/core/service_locator_container/coffee_image_service_locator_cointaner.dart';

final class ServiceLocator {
  GetIt sl;
  static ServiceLocator? _instance;

  ServiceLocator._internal({GetIt? getIt}) : sl = getIt ?? GetIt.instance;

  factory ServiceLocator() {
    _instance ??= ServiceLocator._internal();
    return _instance!;
  }

  void initialize() {
    CoffeeImageServiceLocatorCointaner().register();
  }
}
