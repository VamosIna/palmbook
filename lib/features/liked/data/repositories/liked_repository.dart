import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

abstract class LikedRepository {
  Future<Either<Failure, List<Book>>> getLikedBooks();
  Future<Either<Failure, void>> toggleLikeStatus(Book book);
}
