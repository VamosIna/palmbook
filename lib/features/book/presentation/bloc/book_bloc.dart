import 'package:bloc/bloc.dart';
import 'package:com_palmcode_book/features/book/data/repositories/book_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;
  int page = 1;
  String query = '';
  bool hasReachedMax = false;

  BookBloc({required this.repository}) : super(BookInitial()) {
    on<FetchBooks>(_onFetchBooks);
    on<SearchBooks>(_onSearchBooks);
  }

  void _onFetchBooks(FetchBooks event, Emitter<BookState> emit) async {
    if (state is BookLoaded && (hasReachedMax || event.isInitial)) return;

    if (event.isInitial) {
      page = 1;
      hasReachedMax = false;
      emit(BookLoading());
    }

    try {
      final result = await repository.getBooks(page: page, query: query);

      result.fold((failure) => emit(BookError(message: failure.message)), (
        books,
      ) {
        if (books.isEmpty) {
          hasReachedMax = true;
          if (page == 1) {
            emit(BookEmpty());
          } else {
            emit(
              BookLoaded(
                books: (state as BookLoaded).books,
                hasReachedMax: true,
              ),
            );
          }
        } else {
          page++;
          final currentBooks =
              state is BookLoaded ? (state as BookLoaded).books : <Book>[];

          emit(
            BookLoaded(
              books: [...currentBooks, ...books],
              hasReachedMax: false,
            ),
          );
        }
      });
    } catch (e) {
      emit(BookError(message: 'An unexpected error occurred'));
    }
  }

  void _onSearchBooks(SearchBooks event, Emitter<BookState> emit) {
    query = event.query;
    page = 1;
    hasReachedMax = false;
    add(FetchBooks(isInitial: true));
  }
}
