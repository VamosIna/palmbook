import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final List<String> authors;
  final String? coverUrl;
  final int downloadCount;
  final List<String> subjects;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.coverUrl,
    required this.downloadCount,
    required this.subjects,
  });

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

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      coverUrl: json['coverUrl'],
      downloadCount: json['downloadCount'],
      subjects: List<String>.from(json['subjects']),
    );
  }

  @override
  List<Object?> get props => [id];
}
