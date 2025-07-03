import 'package:bloc/bloc.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository.dart' show LikedRepository;
import 'package:com_palmcode_book/features/liked/presentation/bloc/liked_bloc.dart';
import 'package:com_palmcode_book/injection_container.dart' as di;
import 'package:equatable/equatable.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final LikedRepository likedRepository;

  DetailBloc({required this.likedRepository}) : super(DetailInitial()) {
    on<CheckIfLiked>(_onCheckIfLiked);
    on<ToggleLike>(_onToggleLike);
  }

  void _onCheckIfLiked(CheckIfLiked event, Emitter<DetailState> emit) async {
    try {
      final result = await likedRepository.getLikedBooks();
      result.fold(
        (failure) => emit(DetailError(message: 'Failed to check like status')),
        (books) {
          final isLiked = books.any((book) => book.id == event.bookId);
          emit(BookLiked(isLiked: isLiked));
        },
      );
    } catch (e) {
      emit(DetailError(message: 'Failed to check like status'));
    }
  }

  void _onToggleLike(ToggleLike event, Emitter<DetailState> emit) async {
    try {
      // Kirim state loading saat proses toggle
      emit(LikeUpdating());

      final result = await likedRepository.toggleLikeStatus(event.book);
      result.fold(
        (failure) => emit(DetailError(message: 'Failed to toggle like')),
        (_) {
          // Setelah berhasil, refresh status like
          add(CheckIfLiked(bookId: event.book.id));

          // Trigger refresh di LikedBloc menggunakan GetIt
          di.sl<LikedBloc>().add(LoadLikedBooks());
        },
      );
    } catch (e) {
      emit(DetailError(message: 'Failed to toggle like'));
    }
  }
}
