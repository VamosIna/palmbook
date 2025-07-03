import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:com_palmcode_book/features/liked/data/datasources/local/liked_local_data_source.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

class LikedRepositoryImpl implements LikedRepository {
  final LikedLocalDataSource localDataSource;

  LikedRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Book>>> getLikedBooks() async {
    try {
      final books = await localDataSource.getLikedBooks();
      return Right(books);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleLikeStatus(Book book) async {
    try {
      final likedBooks = await localDataSource.getLikedBooks();
      final isLiked = likedBooks.any((b) => b.id == book.id);

      if (isLiked) {
        await localDataSource.removeLikedBook(book.id);
      } else {
        await localDataSource.addLikedBook(book);
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
