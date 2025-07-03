part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class FetchBooks extends BookEvent {
  final bool isInitial;

  const FetchBooks({this.isInitial = false});

  @override
  List<Object> get props => [isInitial];
}

class SearchBooks extends BookEvent {
  final String query;

  const SearchBooks({required this.query});

  @override
  List<Object> get props => [query];
}
