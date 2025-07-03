import 'package:com_palmcode_book/features/book/data/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:com_palmcode_book/features/book/data/datasources/remote/book_remote_data_source.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Book>>> getBooks({
    int page = 1,
    String query = '',
  }) async {
    try {
      final books = await remoteDataSource.getBooks(page: page, query: query);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
