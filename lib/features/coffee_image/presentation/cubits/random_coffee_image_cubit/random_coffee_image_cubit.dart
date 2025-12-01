import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:very_good_ventures_test/core/service_locator/service_locator.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/repositories/coffee_image_repository.dart';

part 'random_coffee_image_state.dart';

class RandomCoffeeImageCubit extends Cubit<RandomCoffeeImageState> {
  final _coffeeImageRepository = ServiceLocator().sl<CoffeeImageRepository>();
  RandomCoffeeImageCubit() : super(RandomCoffeeImageInitial());

  Future<void> fetchRandomCoffeeImage() async {
    emit(RandomCoffeeImageLoading());

    final imageEither = await _coffeeImageRepository.getRandomCoffeeImage();
    imageEither.fold(
      (failure) => emit(RandomCoffeeImageError(message: failure.message)),
      (url) {
        emit(RandomCoffeeImageLoaded(imageUrl: url));
      },
    );
  }

  void loadSpecificImage(String url) {
    emit(RandomCoffeeImageLoaded(imageUrl: url));
  }
}
