import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

abstract class LikedLocalDataSource {
  Future<List<Book>> getLikedBooks();
  Future<void> addLikedBook(Book book);
  Future<void> removeLikedBook(int bookId);
}
