part of 'random_coffee_image_cubit.dart';

@immutable
sealed class RandomCoffeeImageState extends Equatable {
  const RandomCoffeeImageState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the [RandomCoffeeImageCubit].
final class RandomCoffeeImageInitial extends RandomCoffeeImageState {}

/// Represents the loading state when a random coffee image is being fetched.
final class RandomCoffeeImageLoading extends RandomCoffeeImageState {}

/// Represents the state when a random coffee image has been successfully fetched.
final class RandomCoffeeImageLoaded extends RandomCoffeeImageState {
  /// The URL of the fetched coffee image.
  final String imageUrl;

  const RandomCoffeeImageLoaded({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

/// Represents the state when there was an error fetching the random coffee image.
final class RandomCoffeeImageError extends RandomCoffeeImageState {
  /// The error message associated with the failure.
  final String message;

  const RandomCoffeeImageError({required this.message});

  @override
  List<Object?> get props => [message];
}
