import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_ventures_test/core/either/either.dart';
import 'package:very_good_ventures_test/core/errors/failures/server_failure.dart';
import 'package:very_good_ventures_test/core/service_locator/service_locator.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/entities/coffee_image_entity.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/repositories/coffee_image_repository.dart';
import 'package:very_good_ventures_test/features/coffee_image/presentation/cubits/favorite_coffee_image_cubit/favorite_coffee_images_cubit.dart';

class MockCoffeeImageRepository extends Mock implements CoffeeImageRepository {}

void main() {
  late MockCoffeeImageRepository mockCoffeeImageRepository;
  final testUrl = 'https://example.com/coffee.jpg';

  setUp(() {
    mockCoffeeImageRepository = MockCoffeeImageRepository();
    ServiceLocator().sl.registerSingleton<CoffeeImageRepository>(
      mockCoffeeImageRepository,
    );
  });

  tearDown(() {
    ServiceLocator().sl.reset();
  });

  group('loadFavoriteImages', () {
    blocTest<FavoriteCoffeeImagesCubit, FavoriteCoffeeImagesState>(
      'emits [FavoriteCoffeeImageLoading, FavoriteCoffeeImagesLoaded] when load is successful',
      build: () => FavoriteCoffeeImagesCubit(),
      setUp: () {
        when(() => mockCoffeeImageRepository.getFavorites()).thenAnswer(
          (_) async => const Right([CoffeeImageEntity(file: 'any url here')]),
        );
      },
      act: (cubit) => cubit.loadFavoriteImages(),
      expect: () => <FavoriteCoffeeImagesState>[
        FavoriteCoffeeImageLoading(),
        const FavoriteCoffeeImagesLoaded([
          CoffeeImageEntity(file: 'any url here'),
        ]),
      ],
    );

    blocTest<FavoriteCoffeeImagesCubit, FavoriteCoffeeImagesState>(
      'emits [FavoriteCoffeeImageLoading, FavoriteCoffeeImagesError] when load fails',
      build: () => FavoriteCoffeeImagesCubit(),
      setUp: () {
        when(() => mockCoffeeImageRepository.getFavorites()).thenAnswer(
          (_) async => Left(ServerFailure(message: 'Failed to load favorites')),
        );
      },
      act: (cubit) => cubit.loadFavoriteImages(),
      expect: () => <FavoriteCoffeeImagesState>[
        FavoriteCoffeeImageLoading(),
        const FavoriteCoffeeImagesError('Failed to load favorites'),
      ],
    );
  });

  group('saveFavorite', () {
    blocTest<FavoriteCoffeeImagesCubit, FavoriteCoffeeImagesState>(
      'emits [FavoriteCoffeeImageSaving, FavoriteCoffeeImageSaved] when save is successful',
      build: () => FavoriteCoffeeImagesCubit(),
      seed: () => const FavoriteCoffeeImagesLoaded([]),
      setUp: () {
        when(
          () => mockCoffeeImageRepository.saveFavorite(testUrl),
        ).thenAnswer((_) async => Right([CoffeeImageEntity(file: testUrl)]));
      },
      act: (cubit) => cubit.saveFavorite(url: testUrl),
      expect: () => <FavoriteCoffeeImagesState>[
        const FavoriteCoffeeImageSaving([]),
        FavoriteCoffeeImageSaved([CoffeeImageEntity(file: testUrl)]),
      ],
    );

    blocTest<FavoriteCoffeeImagesCubit, FavoriteCoffeeImagesState>(
      'emits [FavoriteCoffeeImageSaving, FavoriteCoffeeImagesError] when save fails',
      build: () => FavoriteCoffeeImagesCubit(),
      seed: () => const FavoriteCoffeeImagesLoaded([]),
      setUp: () {
        when(() => mockCoffeeImageRepository.saveFavorite(testUrl)).thenAnswer(
          (_) async => Left(ServerFailure(message: 'Failed to save favorite')),
        );
      },
      act: (cubit) => cubit.saveFavorite(url: testUrl),
      expect: () => <FavoriteCoffeeImagesState>[
        const FavoriteCoffeeImageSaving([]),
        const FavoriteCoffeeImagesError('Failed to save favorite'),
      ],
    );
  });

  group('removeFavorite', () {
    blocTest<FavoriteCoffeeImagesCubit, FavoriteCoffeeImagesState>(
      'emits [FavoriteCoffeeImageSaving, FavoriteCoffeeImageSaved] when remove is successful',
      build: () => FavoriteCoffeeImagesCubit(),
      seed: () =>
          FavoriteCoffeeImagesLoaded([CoffeeImageEntity(file: testUrl)]),
      setUp: () {
        when(
          () => mockCoffeeImageRepository.removeFavorite(testUrl),
        ).thenAnswer((_) async => const Right([]));
      },
      act: (cubit) => cubit.removeFavorite(url: testUrl),
      expect: () => <FavoriteCoffeeImagesState>[
        FavoriteCoffeeImageSaving([CoffeeImageEntity(file: testUrl)]),
        const FavoriteCoffeeImageSaved([]),
      ],
    );

    blocTest<FavoriteCoffeeImagesCubit, FavoriteCoffeeImagesState>(
      'emits [FavoriteCoffeeImageSaving, FavoriteCoffeeImagesError] when remove fails',
      build: () => FavoriteCoffeeImagesCubit(),
      seed: () =>
          FavoriteCoffeeImagesLoaded([CoffeeImageEntity(file: testUrl)]),
      setUp: () {
        when(
          () => mockCoffeeImageRepository.removeFavorite(testUrl),
        ).thenAnswer(
          (_) async =>
              Left(ServerFailure(message: 'Failed to remove favorite')),
        );
      },
      act: (cubit) => cubit.removeFavorite(url: testUrl),
      expect: () => <FavoriteCoffeeImagesState>[
        FavoriteCoffeeImageSaving([CoffeeImageEntity(file: testUrl)]),
        const FavoriteCoffeeImagesError('Failed to remove favorite'),
      ],
    );
  });

  group('isFavorited', () {
    test('returns true when the image is in favorites', () {
      final cubit = FavoriteCoffeeImagesCubit();
      cubit.emit(
        FavoriteCoffeeImagesLoaded([CoffeeImageEntity(file: testUrl)]),
      );

      final isFavorited = cubit.isFavorited(testUrl);

      expect(isFavorited, isTrue);
    });

    test('returns false when the image is not in favorites', () {
      final cubit = FavoriteCoffeeImagesCubit();
      cubit.emit(
        const FavoriteCoffeeImagesLoaded([
          CoffeeImageEntity(file: 'other url'),
        ]),
      );

      final isFavorited = cubit.isFavorited(testUrl);

      expect(isFavorited, isFalse);
    });

    test('returns false when state is not FavoriteCoffeeImagesLoaded', () {
      final cubit = FavoriteCoffeeImagesCubit();

      final isFavorited = cubit.isFavorited(testUrl);

      expect(isFavorited, isFalse);
    });
  });
}
