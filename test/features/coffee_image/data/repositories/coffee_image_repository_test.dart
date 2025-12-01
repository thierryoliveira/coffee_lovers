import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_ventures_test/core/either/either.dart';
import 'package:very_good_ventures_test/core/errors/failures/failure.dart';
import 'package:very_good_ventures_test/core/errors/failures/local_storage_failure.dart';
import 'package:very_good_ventures_test/core/errors/failures/server_failure.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/local/coffee_image_local_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/remote/coffee_image_remote_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/models/coffee_image_model.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/repositories/coffee_image_repository_impl.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/entities/coffee_image_entity.dart';
import 'package:very_good_ventures_test/features/coffee_image/domain/repositories/coffee_image_repository.dart';

class MockCoffeeImageRemoteDataSource extends Mock
    implements CoffeeImageRemoteDataSource {}

class MockCoffeeImageLocalDataSource extends Mock
    implements CoffeeImageLocalDataSource {}

void main() {
  late CoffeeImageRepository repository;
  late CoffeeImageRemoteDataSource remoteDataSource;
  late CoffeeImageLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockCoffeeImageRemoteDataSource();
    localDataSource = MockCoffeeImageLocalDataSource();
    repository = CoffeeImageRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  group('getRandomCoffeeImage', () {
    test('should return a Right with an URL when successful', () async {
      when(
        () => remoteDataSource.getRandomCoffeeImage(),
      ).thenAnswer((_) async => const CoffeeImageModel(file: 'file_url'));
      final result = await repository.getRandomCoffeeImage();
      expect(result, const Right<Failure, String>('file_url'));
    });

    test(
      'should return a Left with ServerFailure when an exception occurs',
      () async {
        when(
          () => remoteDataSource.getRandomCoffeeImage(),
        ).thenThrow(Exception('Server error'));
        final result = await repository.getRandomCoffeeImage();
        expect(
          result,
          isA<Left<Failure, String>>().having(
            (left) => left.value,
            'value',
            isA<ServerFailure>(),
          ),
        );
      },
    );

    test('should return a Left of ServerFailure if the url is null', () {
      when(
        () => remoteDataSource.getRandomCoffeeImage(),
      ).thenAnswer((_) async => const CoffeeImageModel(file: null));
      final result = repository.getRandomCoffeeImage();
      expect(
        result,
        completion(
          isA<Left<Failure, String>>().having(
            (left) => left.value,
            'value',
            isA<ServerFailure>().having(
              (failure) => failure.message,
              'message',
              'Received an invalid image URL from the server.',
            ),
          ),
        ),
      );
    });

    test('should return a Left os ServerFailure if the url is empty', () async {
      when(
        () => remoteDataSource.getRandomCoffeeImage(),
      ).thenAnswer((_) async => const CoffeeImageModel(file: ''));
      final result = repository.getRandomCoffeeImage();
      expect(
        result,
        completion(
          isA<Left<Failure, String>>().having(
            (left) => left.value,
            'value',
            isA<ServerFailure>().having(
              (failure) => failure.message,
              'message',
              'Received an invalid image URL from the server.',
            ),
          ),
        ),
      );
    });
  });

  group('saveFavorite', () {
    test(
      'should return a Right with updated favorites when successful',
      () async {
        const url = 'https://example.com/coffee.jpg';
        final mockFavorites = const [
          CoffeeImageModel(file: 'https://example.com/coffee1.jpg'),
          CoffeeImageModel(file: 'https://example.com/coffee2.jpg'),
        ];
        when(() => localDataSource.saveFavorite(url)).thenAnswer((_) async {});
        when(
          () => localDataSource.getFavoriteUrls(),
        ).thenAnswer((_) async => mockFavorites);

        final result = await repository.saveFavorite(url);

        expect(
          result,
          Right<Failure, List<CoffeeImageEntity>>(
            mockFavorites
                .map((model) => CoffeeImageEntity(file: model.file!))
                .toList(),
          ),
        );
        verify(() => localDataSource.saveFavorite(url)).called(1);
        verify(() => localDataSource.getFavoriteUrls()).called(1);
      },
    );

    test(
      'should return a Left with LocalStorageFailure when an exception occurs',
      () async {
        const url = 'https://example.com/coffee.jpg';
        when(
          () => localDataSource.saveFavorite(url),
        ).thenThrow(Exception('Local storage error'));

        final result = await repository.saveFavorite(url);

        expect(
          result,
          const Left<Failure, List<CoffeeImageEntity>>(
            LocalStorageFailure(
              message:
                  'Something went wrong trying to add an image to the favorites.',
            ),
          ),
        );
        verify(() => localDataSource.saveFavorite(url)).called(1);
      },
    );
  });

  group('getFavorites', () {
    test('should return a Right with favorites when successful', () async {
      final mockFavorites = const [
        CoffeeImageModel(file: 'https://example.com/coffee1.jpg'),
        CoffeeImageModel(file: 'https://example.com/coffee2.jpg'),
      ];
      when(
        () => localDataSource.getFavoriteUrls(),
      ).thenAnswer((_) async => mockFavorites);

      final result = await repository.getFavorites();

      expect(
        result,
        Right<Failure, List<CoffeeImageEntity>>(
          mockFavorites
              .map((model) => CoffeeImageEntity(file: model.file!))
              .toList(),
        ),
      );
      verify(() => localDataSource.getFavoriteUrls()).called(1);
    });

    test(
      'should return a Left with LocalStorageFailure when an exception occurs',
      () async {
        when(
          () => localDataSource.getFavoriteUrls(),
        ).thenThrow(Exception('Local storage error'));

        final result = await repository.getFavorites();

        expect(
          result,
          const Left<Failure, List<CoffeeImageEntity>>(
            LocalStorageFailure(
              message:
                  'Something went wrong trying to get all favorited images',
            ),
          ),
        );
        verify(() => localDataSource.getFavoriteUrls()).called(1);
      },
    );
  });

  group('removeFavorite', () {
    test(
      'should return a Right with updated favorites when successful',
      () async {
        const url = 'https://example.com/coffee.jpg';
        final mockFavorites = const [
          CoffeeImageModel(file: 'https://example.com/coffee1.jpg'),
        ];
        when(
          () => localDataSource.removeFavorite(url),
        ).thenAnswer((_) async {});
        when(
          () => localDataSource.getFavoriteUrls(),
        ).thenAnswer((_) async => mockFavorites);

        final result = await repository.removeFavorite(url);

        expect(
          result,
          Right<Failure, List<CoffeeImageEntity>>(
            mockFavorites
                .map((model) => CoffeeImageEntity(file: model.file!))
                .toList(),
          ),
        );
        verify(() => localDataSource.removeFavorite(url)).called(1);
        verify(() => localDataSource.getFavoriteUrls()).called(1);
      },
    );

    test(
      'should return a Left with LocalStorageFailure when an exception occurs',
      () async {
        const url = 'https://example.com/coffee.jpg';
        when(
          () => localDataSource.removeFavorite(url),
        ).thenThrow(Exception('Local storage error'));

        final result = await repository.removeFavorite(url);

        expect(
          result,
          const Left<Failure, List<CoffeeImageEntity>>(
            LocalStorageFailure(
              message:
                  'Something went wrong trying to remove an item from favorites',
            ),
          ),
        );
        verify(() => localDataSource.removeFavorite(url)).called(1);
      },
    );
  });
}
