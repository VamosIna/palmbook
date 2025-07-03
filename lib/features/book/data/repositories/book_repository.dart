import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepository {
  Future<Either<Failure, List<Book>>> getBooks({
    int page = 1,
    String query = '',
  });
}
