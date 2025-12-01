import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_ventures_test/core/service_locator/service_locator.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/entities/coffee_image_entity.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/repositories/coffee_image_repository.dart';

part 'favorite_coffee_images_state.dart';

class FavoriteCoffeeImagesCubit extends Cubit<FavoriteCoffeeImagesState> {
  final _coffeeImagesRepository = ServiceLocator().sl<CoffeeImageRepository>();

  FavoriteCoffeeImagesCubit() : super(FavoriteCoffeeImagesInitial());

  Future<void> loadFavoriteImages() async {
    emit(FavoriteCoffeeImageLoading());

    final favoritesEither = await _coffeeImagesRepository.getFavorites();

    favoritesEither.fold(
      (failure) => emit(FavoriteCoffeeImagesError(failure.message)),
      (favorites) => emit(FavoriteCoffeeImagesLoaded(favorites)),
    );
  }

  Future<void> saveFavorite({required String url}) async {
    final currentState = state;
    if (currentState is! FavoriteCoffeeImagesLoaded) return;
    emit(FavoriteCoffeeImageSaving(currentState.coffeeImages));
    final either = await _coffeeImagesRepository.saveFavorite(url);
    either.fold(
      (failure) => emit(FavoriteCoffeeImagesError(failure.message)),
      (favorites) => emit(FavoriteCoffeeImageSaved(favorites)),
    );
  }

  Future<void> removeFavorite({required String url}) async {
    final currentState = state;
    if (currentState is! FavoriteCoffeeImagesLoaded) return;
    emit(FavoriteCoffeeImageSaving(currentState.coffeeImages));
    final either = await _coffeeImagesRepository.removeFavorite(url);
    either.fold((failure) => emit(FavoriteCoffeeImagesError(failure.message)), (
      updatedFavorites,
    ) {
      emit(FavoriteCoffeeImageSaved(updatedFavorites));
    });
  }

  bool isFavorited(String url) {
    final currentState = state;
    if (currentState is! FavoriteCoffeeImagesLoaded) return false;
    return currentState.coffeeImages.any(
      (coffeeImage) => coffeeImage.file == url,
    );
  }
}
