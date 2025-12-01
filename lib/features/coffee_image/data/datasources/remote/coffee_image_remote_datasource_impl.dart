import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:very_good_ventures_test/core/errors/exceptions/server_exception.dart';
import 'package:very_good_ventures_test/features/coffee_image/core/constants/coffee_image_endpoints.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/datasources/remote/coffee_image_remote_datasource.dart';
import 'package:very_good_ventures_test/features/coffee_image/data/models/coffee_image_model.dart';

class CoffeeImageRemoteDatasourceImpl implements CoffeeImageRemoteDataSource {
  final http.Client _client;

  CoffeeImageRemoteDatasourceImpl({required http.Client client})
    : _client = client;

  @override
  Future<CoffeeImageModel> getRandomCoffeeImage() async {
    final response = await _client.get(
      Uri.parse(CoffeeImageEndpoints.randomCoffeeImage),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CoffeeImageModel.fromJson(data);
    } else {
      throw ServerException(message: response.reasonPhrase ?? 'Unknown error');
    }
  }
}
