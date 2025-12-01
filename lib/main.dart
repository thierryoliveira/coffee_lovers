import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_ventures_test/core/local_storage/local_storage.dart';
import 'package:very_good_ventures_test/core/routes/routes.dart';
import 'package:very_good_ventures_test/core/service_locator/service_locator.dart';
import 'package:very_good_ventures_test/features/coffee_image/presentation/cubits/favorite_coffee_image_cubit/favorite_coffee_images_cubit.dart';
import 'package:very_good_ventures_test/features/coffee_image/presentation/cubits/random_coffee_image_cubit/random_coffee_image_cubit.dart';
import 'package:very_good_ventures_test/features/coffee_image/presentation/screen/random_coffee_image_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().initialize();
  ServiceLocator().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Lovers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => RandomCoffeeImageCubit()),
            BlocProvider(create: (context) => FavoriteCoffeeImagesCubit()),
          ],
          child: const RandomCoffeeImageScreen(),
        ),
      },
    );
  }
}
