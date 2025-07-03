import 'dart:convert';
import 'package:com_palmcode_book/features/book/data/datasources/remote/book_remote_data_source.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:http/http.dart' as http;
import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:com_palmcode_book/features/book/data/models/book_model.dart';

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final http.Client client;

  BookRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Book>> getBooks({int page = 1, String query = ''}) async {
    final response = await client.get(
      Uri.parse(
        'https://gutendex.com/books?page=$page&search=${Uri.encodeQueryComponent(query)}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((book) => BookModel.fromJson(book))
          .toList();
    } else {
      throw ServerException(
        message: 'Failed to load books: ${response.statusCode}',
      );
    }
  }
}
