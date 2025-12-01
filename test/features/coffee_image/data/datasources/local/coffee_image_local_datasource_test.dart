import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/local/coffee_image_local_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/local/coffee_image_local_datasource_impl.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late CoffeeImageLocalDataSource dataSource;
  late Box<String> favoritesBox;

  setUp(() async {
    favoritesBox = MockBox();
    dataSource = CoffeeImageLocalDataSourceImpl(favoritesBox: favoritesBox);

    when(() => favoritesBox.values).thenReturn(<String>[]);
    // when(() => favoritesBox.deleteAt(any())).thenAnswer((_) async {});
  });

  group('saveFavorite', () {
    test('should return an index when successfully added', () {
      when(() => favoritesBox.add(any())).thenAnswer((_) async => 0);
      const url = 'https://example.com/coffee.jpg';

      final future = dataSource.saveFavorite(url);

      expect(future, completes);
      verify(() => favoritesBox.add(url)).called(1);
    });

    test('should throw an exception when adding fails', () {
      when(() => favoritesBox.add(any())).thenThrow(Exception());
      const url = 'https://example.com/coffee.jpg';

      final future = dataSource.saveFavorite(url);

      expect(future, throwsA(isA<Exception>()));
      verify(() => favoritesBox.add(url)).called(1);
    });
  });

  group('getFavorirteUrls', () {
    test('should return a list of CoffeeImageModel when successful', () async {
      const url1 = 'https://example.com/coffee1.jpg';
      const url2 = 'https://example.com/coffee2.jpg';
      when(() => favoritesBox.values).thenReturn(<String>[url1, url2]);

      final result = await dataSource.getFavoriteUrls();

      expect(result.length, 2);
      expect(result[0].file, url1);
      expect(result[1].file, url2);
      verify(() => favoritesBox.values).called(1);
    });

    test('should return an empty list when there are no favorites', () async {
      when(() => favoritesBox.values).thenReturn(<String>[]);

      final result = await dataSource.getFavoriteUrls();

      expect(result, isEmpty);
      verify(() => favoritesBox.values).called(1);
    });
  });

  group('removeFavorite', () {
    test('should delete the favorite when it exists', () async {
      const url = 'https://example.com/coffee.jpg';
      when(() => favoritesBox.values).thenReturn(<String>[url]);
      when(() => favoritesBox.deleteAt(any())).thenAnswer((_) async {});

      final future = dataSource.removeFavorite(url);

      expect(future, completes);
      verify(() => favoritesBox.values).called(1);
      verify(() => favoritesBox.deleteAt(0)).called(1);
    });

    test('should do nothing when the favorite does not exist', () async {
      const url = 'https://example.com/coffee.jpg';
      when(() => favoritesBox.values).thenReturn(<String>[]);

      final future = dataSource.removeFavorite(url);

      expect(future, completes);
      verify(() => favoritesBox.values).called(1);
      verifyNever(() => favoritesBox.deleteAt(any()));
    });
  });
}
