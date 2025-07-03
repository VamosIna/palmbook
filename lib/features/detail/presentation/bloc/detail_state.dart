part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class BookLiked extends DetailState {
  final bool isLiked;

  const BookLiked({required this.isLiked});

  @override
  List<Object> get props => [isLiked];
}

class LikeUpdating extends DetailState {}

class LikeUpdated extends DetailState {
  final Book book;

  const LikeUpdated({required this.book});

  @override
  List<Object> get props => [book];
}

class DetailError extends DetailState {
  final String message;

  const DetailError({required this.message});

  @override
  List<Object> get props => [message];
}
