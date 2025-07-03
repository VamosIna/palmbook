part of 'book_bloc.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;
  final bool hasReachedMax;

  const BookLoaded({required this.books, this.hasReachedMax = false});

  @override
  List<Object> get props => [books, hasReachedMax];
}

class BookEmpty extends BookState {}

class BookError extends BookState {
  final String message;

  const BookError({required this.message});

  @override
  List<Object> get props => [message];
}
