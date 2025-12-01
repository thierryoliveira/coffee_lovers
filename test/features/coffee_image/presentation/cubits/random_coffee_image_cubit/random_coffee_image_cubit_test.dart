import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_ventures_test/core/either/either.dart';
import 'package:very_good_ventures_test/core/errors/failures/server_failure.dart';
import 'package:very_good_ventures_test/core/service_locator/service_locator.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/repositories/coffee_image_repository.dart';
import 'package:very_good_ventures_test/features/coffee_image/presentation/cubits/random_coffee_image_cubit/random_coffee_image_cubit.dart';

class MockCoffeeImageRepository extends Mock implements CoffeeImageRepository {}

void main() {
  late MockCoffeeImageRepository mockCoffeeImageRepository;

  setUp(() {
    mockCoffeeImageRepository = MockCoffeeImageRepository();
    ServiceLocator().sl.registerSingleton<CoffeeImageRepository>(
      mockCoffeeImageRepository,
    );
  });

  tearDown(() {
    ServiceLocator().sl.reset();
  });

  group('fetchRandomCoffeeImage', () {
    final testImageUrl = 'https://example.com/coffee.jpg';

    blocTest<RandomCoffeeImageCubit, RandomCoffeeImageState>(
      'emits [RandomCoffeeImageLoading, RandomCoffeeImageLoaded] when fetch is successful',
      build: () => RandomCoffeeImageCubit(),
      setUp: () {
        when(
          () => mockCoffeeImageRepository.getRandomCoffeeImage(),
        ).thenAnswer((_) async => Right(testImageUrl));
      },
      act: (cubit) => cubit.fetchRandomCoffeeImage(),
      expect: () => <RandomCoffeeImageState>[
        RandomCoffeeImageLoading(),
        RandomCoffeeImageLoaded(imageUrl: testImageUrl),
      ],
    );

    blocTest<RandomCoffeeImageCubit, RandomCoffeeImageState>(
      'emits [RandomCoffeeImageLoading, RandomCoffeeImageError] when fetch fails',
      build: () => RandomCoffeeImageCubit(),
      setUp: () {
        when(() => mockCoffeeImageRepository.getRandomCoffeeImage()).thenAnswer(
          (_) async => Left(ServerFailure(message: 'Failed to fetch image')),
        );
      },
      act: (cubit) => cubit.fetchRandomCoffeeImage(),
      expect: () => <RandomCoffeeImageState>[
        RandomCoffeeImageLoading(),
        const RandomCoffeeImageError(message: 'Failed to fetch image'),
      ],
    );
  });

  blocTest<RandomCoffeeImageCubit, RandomCoffeeImageState>(
    'emits [RandomCoffeeImageLoaded] with correct values when loadSpecificImage is called',
    build: () => RandomCoffeeImageCubit(),
    act: (cubit) =>
        cubit.loadSpecificImage('https://example.com/specific_coffee.jpg'),
    expect: () => <RandomCoffeeImageState>[
      const RandomCoffeeImageLoaded(
        imageUrl: 'https://example.com/specific_coffee.jpg',
      ),
    ],
  );
}
