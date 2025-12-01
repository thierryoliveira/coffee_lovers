part of 'favorite_coffee_images_cubit.dart';

sealed class FavoriteCoffeeImagesState extends Equatable {
  const FavoriteCoffeeImagesState();

  @override
  List<Object> get props => [];
}

final class FavoriteCoffeeImagesInitial extends FavoriteCoffeeImagesState {}

final class FavoriteCoffeeImageLoading extends FavoriteCoffeeImagesState {}

final class FavoriteCoffeeImageSaving extends FavoriteCoffeeImagesLoaded {
  const FavoriteCoffeeImageSaving(super.coffeeImages);
}

final class FavoriteCoffeeImagesLoaded extends FavoriteCoffeeImagesState {
  const FavoriteCoffeeImagesLoaded(this.coffeeImages);

  final List<CoffeeImageEntity> coffeeImages;

  @override
  List<Object> get props => [coffeeImages];
}

final class FavoriteCoffeeImageSaved extends FavoriteCoffeeImagesLoaded {
  const FavoriteCoffeeImageSaved(super.coffeeImages);
}

final class FavoriteCoffeeImagesError extends FavoriteCoffeeImagesState {
  const FavoriteCoffeeImagesError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
