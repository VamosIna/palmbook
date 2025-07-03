import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    required int id,
    required String title,
    required List<String> authors,
    String? coverUrl,
    required int downloadCount,
    required List<String> subjects,
  }) : super(
         id: id,
         title: title,
         authors: authors,
         coverUrl: coverUrl,
         downloadCount: downloadCount,
         subjects: subjects,
       );

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      authors: List<String>.from(json['authors'].map((a) => a['name'])),
      coverUrl: json['formats']['image/jpeg'] ?? json['formats']['image/png'],
      downloadCount: json['download_count'],
      subjects: List<String>.from(json['subjects'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'coverUrl': coverUrl,
      'downloadCount': downloadCount,
      'subjects': subjects,
    };
  }
}
