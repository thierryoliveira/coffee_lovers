import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_ventures_test/core/errors/exceptions/server_exception.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/remote/coffee_image_remote_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/remote/coffee_image_remote_datasource_impl.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/models/coffee_image_model.dart';

class MockClient extends Mock implements Client {}

void main() {
  late CoffeeImageRemoteDataSource datasource;
  late Client client;

  setUp(() {
    client = MockClient();
    datasource = CoffeeImageRemoteDataSourceImpl(client: client);

    registerFallbackValue(
      Uri.parse('https://coffee.alexflipnote.dev/random.json'),
    );
  });

  group('getRandomCoffeeImage', () {
    test(
      'should perform a GET request to the random coffee image endpoint',
      () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => Response(
            '{"file":"https://coffee.alexflipnote.dev/random.jpg"}',
            200,
          ),
        );

        await datasource.getRandomCoffeeImage();

        verify(
          () => client.get(
            Uri.parse('https://coffee.alexflipnote.dev/random.json'),
          ),
        ).called(1);
      },
    );

    test(
      'should return a CoffeeImageModel when the response code is 200',
      () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => Response(
            '{"file":"https://coffee.alexflipnote.dev/random.jpg"}',
            200,
          ),
        );

        final result = await datasource.getRandomCoffeeImage();

        expect(
          result,
          const CoffeeImageModel(
            file: 'https://coffee.alexflipnote.dev/random.jpg',
          ),
        );
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        when(
          () => client.get(any()),
        ).thenAnswer((_) async => Response('Not Found', 404));

        expect(
          () => datasource.getRandomCoffeeImage(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
