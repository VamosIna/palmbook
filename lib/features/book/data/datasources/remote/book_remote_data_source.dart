import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

abstract class BookRemoteDataSource {
  Future<List<Book>> getBooks({int page = 1, String query = ''});
}
