part of 'liked_bloc.dart';

abstract class LikedState extends Equatable {
  const LikedState();

  @override
  List<Object> get props => [];
}

class LikedInitial extends LikedState {}

class LikedLoading extends LikedState {}

class LikedLoaded extends LikedState {
  final List<Book> books;

  const LikedLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

class LikedError extends LikedState {
  final String message;

  const LikedError({required this.message});

  @override
  List<Object> get props => [message];
}
