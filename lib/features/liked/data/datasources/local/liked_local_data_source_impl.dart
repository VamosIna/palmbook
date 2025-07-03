import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:com_palmcode_book/features/liked/data/datasources/local/liked_local_data_source.dart';

class LikedLocalDataSourceImpl implements LikedLocalDataSource {
  static const String _likedBooksKey = 'liked_books';
  final SharedPreferences sharedPreferences;

  LikedLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Book>> getLikedBooks() async {
    final jsonString = sharedPreferences.getString(_likedBooksKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to parse liked books');
    }
  }

  @override
  Future<void> addLikedBook(Book book) async {
    try {
      final likedBooks = await getLikedBooks();
      if (!likedBooks.any((b) => b.id == book.id)) {
        likedBooks.add(book);
        await _saveLikedBooks(likedBooks);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to add liked book');
    }
  }

  @override
  Future<void> removeLikedBook(int bookId) async {
    try {
      final likedBooks = await getLikedBooks();
      likedBooks.removeWhere((book) => book.id == bookId);
      await _saveLikedBooks(likedBooks);
    } catch (e) {
      throw CacheException(message: 'Failed to remove liked book');
    }
  }

  Future<void> _saveLikedBooks(List<Book> books) async {
    final jsonList = books.map((book) => book.toJson()).toList();
    await sharedPreferences.setString(_likedBooksKey, json.encode(jsonList));
  }
}
