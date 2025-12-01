import 'package:very_good_ventures_test/core/service_locator/service_locator.dart';

abstract class ServiceLocatorContainer {
  final serviceLocator = ServiceLocator();

  /// Registers the dependencies in the service locator.
  void register();
}
