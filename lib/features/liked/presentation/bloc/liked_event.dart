part of 'liked_bloc.dart';

abstract class LikedEvent extends Equatable {
  const LikedEvent();

  @override
  List<Object> get props => [];
}

class LoadLikedBooks extends LikedEvent {}

class ToggleBookLike extends LikedEvent {
  final Book book;

  const ToggleBookLike({required this.book});

  @override
  List<Object> get props => [book];
}
