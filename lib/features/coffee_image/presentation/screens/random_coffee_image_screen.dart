import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_ventures_test/core/routes/routes.dart';
import 'package:very_good_ventures_test/features/coffee_image/presentation/cubits/favorite_coffee_image_cubit/favorite_coffee_images_cubit.dart';
import 'package:very_good_ventures_test/features/coffee_image/presentation/cubits/random_coffee_image_cubit/random_coffee_image_cubit.dart';

class RandomCoffeeImageScreen extends StatefulWidget {
  const RandomCoffeeImageScreen({super.key});

  @override
  State<RandomCoffeeImageScreen> createState() =>
      _RandomCoffeeImageScreenState();
}

class _RandomCoffeeImageScreenState extends State<RandomCoffeeImageScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RandomCoffeeImageCubit>().fetchRandomCoffeeImage();
    context.read<FavoriteCoffeeImagesCubit>().loadFavoriteImages();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomCoffeeImageCubit, RandomCoffeeImageState>(
      builder: (context, state) {
        final currentState = state;
        final isImageLoaded = currentState is RandomCoffeeImageLoaded;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Random Coffee Image',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.blueAccent,
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state is RandomCoffeeImageLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is RandomCoffeeImageLoaded) {
                  final imageUrl = state.imageUrl;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,

                                  placeholder: (context, url) => LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SizedBox(
                                        height: 300,
                                        width: constraints.maxWidth,
                                        child: ColoredBox(
                                          color: Colors.grey.shade300
                                              .withValues(alpha: 0.1),
                                        ),
                                      );
                                    },
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is RandomCoffeeImageError) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🚫📷', style: TextStyle(fontSize: 100)),
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Something went wrong when loading an amazing image. Why not shuffle it or check your favorites?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          bottomNavigationBar: _ActionButtons(
            imageUrl: isImageLoaded ? currentState.imageUrl : null,
            isLoading: state is RandomCoffeeImageLoading,
          ),
        );
      },
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String? imageUrl;
  final bool isLoading;

  const _ActionButtons({required this.imageUrl, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    final hasValidUrl = !isLoading && imageUrl != null && imageUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _Button(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  Routes.favorites,
                );
                if (context.mounted && result is String && result.isNotEmpty) {
                  context.read<RandomCoffeeImageCubit>().loadSpecificImage(
                    result,
                  );
                }
              },
              label: 'Favorites',
              icon: Icons.list_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _Button(
              onPressed: context
                  .read<RandomCoffeeImageCubit>()
                  .fetchRandomCoffeeImage,
              label: 'Shuffle',
              icon: Icons.shuffle,
              isLoading: isLoading,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child:
                BlocBuilder<
                  FavoriteCoffeeImagesCubit,
                  FavoriteCoffeeImagesState
                >(
                  builder: (context, state) {
                    final isFavorited =
                        hasValidUrl &&
                        context.read<FavoriteCoffeeImagesCubit>().isFavorited(
                          imageUrl,
                        );
                    return _Button(
                      onPressed: hasValidUrl
                          ? () {
                              isFavorited
                                  ? context
                                        .read<FavoriteCoffeeImagesCubit>()
                                        .removeFavorite(url: imageUrl)
                                  : context
                                        .read<FavoriteCoffeeImagesCubit>()
                                        .saveFavorite(url: imageUrl);
                            }
                          : null,
                      label: 'Loved it',
                      icon: isFavorited
                          ? Icons.favorite
                          : Icons.favorite_border,
                      isLoading:
                          state is FavoriteCoffeeImageSaving || isLoading,
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  const _Button({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isLoading
            ? Colors.blueAccent.withValues(alpha: 0.5)
            : Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
