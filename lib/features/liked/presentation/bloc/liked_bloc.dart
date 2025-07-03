import 'package:bloc/bloc.dart';
import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

part 'liked_event.dart';
part 'liked_state.dart';

class LikedBloc extends Bloc<LikedEvent, LikedState> {
  final LikedRepository repository;

  LikedBloc({required this.repository}) : super(LikedInitial()) {
    on<LoadLikedBooks>(_onLoadLikedBooks);
  }

  void _onLoadLikedBooks(LoadLikedBooks event, Emitter<LikedState> emit) async {
    emit(LikedLoading());

    try {
      final result = await repository.getLikedBooks();
      result.fold(
        (failure) => emit(LikedError(message: failure.message)),
        (books) => emit(LikedLoaded(books: books)),
      );
    } catch (e) {
      emit(LikedError(message: 'An unexpected error occurred'));
    }
  }
}
