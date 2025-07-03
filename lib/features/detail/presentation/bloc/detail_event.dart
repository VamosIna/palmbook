part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class CheckIfLiked extends DetailEvent {
  final int bookId;

  const CheckIfLiked({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class ToggleLike extends DetailEvent {
  final Book book;

  const ToggleLike({required this.book});

  @override
  List<Object> get props => [book];
}
