import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

class Storage {
  static const String _likedBooksKey = 'liked_books';

  final SharedPreferences prefs;

  Storage({required this.prefs});

  Future<List<Book>> getLikedBooks() async {
    final jsonString = prefs.getString(_likedBooksKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }


  Future<void> saveLikedBooks(List<Book> books) async {
    final jsonList = books.map((book) => book.toJson()).toList();
    await prefs.setString(_likedBooksKey, json.encode(jsonList));
  }
}
