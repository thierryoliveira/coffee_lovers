import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_ventures_test/features/coffee_image/presentation/cubits/favorite_coffee_image_cubit/favorite_coffee_images_cubit.dart';

class FavoriteCoffeeImagesScreen extends StatefulWidget {
  const FavoriteCoffeeImagesScreen({super.key});

  @override
  State<FavoriteCoffeeImagesScreen> createState() =>
      _FavoriteCoffeeImagesScreenState();
}

class _FavoriteCoffeeImagesScreenState
    extends State<FavoriteCoffeeImagesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteCoffeeImagesCubit>().loadFavoriteImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your favorite images')),
      body: BlocBuilder<FavoriteCoffeeImagesCubit, FavoriteCoffeeImagesState>(
        builder: (context, state) {
          if (state is! FavoriteCoffeeImagesLoaded) {
            return const SizedBox.shrink();
          }
          final images = state.coffeeImages;
          if (images.isEmpty) {
            return const Center(child: Text('Nenhuma imagem favorita.'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return GestureDetector(
                  onTap: () => Navigator.pop(context, image.file),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: image.file ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
