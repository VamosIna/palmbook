import 'dart:convert';
import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;

class DioClient {
  final http.Client client;

  DioClient(this.client);

  Future<dynamic> get(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException(
        message: 'Failed to load data: ${response.statusCode}',
      );
    }
  }
}
