import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:com_palmcode_book/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:dartz/dartz.dart';
import 'package:com_palmcode_book/core/errors/exceptions.dart';

import 'detail_bloc_test.mocks.dart';

@GenerateMocks([LikedRepository])
void main() {
  late DetailBloc bloc;
  late MockLikedRepository mockRepository;

  setUp(() {
    mockRepository = MockLikedRepository();
    bloc = DetailBloc(likedRepository: mockRepository);
  });

  final tBook = Book(
    id: 1,
    title: 'Test',
    authors: ['Author'],
    coverUrl: 'https://example.com/cover.jpg',
    downloadCount: 10,
    subjects: ['Fiction'],
  );

  blocTest<DetailBloc, DetailState>(
    'emits [BookLiked(isLiked: true)] when CheckIfLiked is added and book is liked',
    build: () {
      when(mockRepository.getLikedBooks())
          .thenAnswer((_) async => Right([tBook]));
      return bloc;
    },
    act: (bloc) => bloc.add(CheckIfLiked(bookId: 1)),
    expect: () => [
      BookLiked(isLiked: true),
    ],
  );

  blocTest<DetailBloc, DetailState>(
    'emits [BookLiked(isLiked: false)] when CheckIfLiked is added and book is not liked',
    build: () {
      when(mockRepository.getLikedBooks())
          .thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(CheckIfLiked(bookId: 1)),
    expect: () => [
      BookLiked(isLiked: false),
    ],
  );

  blocTest<DetailBloc, DetailState>(
    'emits [DetailError] when CheckIfLiked is added and repository returns failure',
    build: () {
      when(mockRepository.getLikedBooks())
          .thenAnswer((_) async => Left(GenericFailure('error')));
      return bloc;
    },
    act: (bloc) => bloc.add(CheckIfLiked(bookId: 1)),
    expect: () => [
      isA<DetailError>(),
    ],
  );

  blocTest<DetailBloc, DetailState>(
    'emits [LikeUpdating, BookLiked] when ToggleLike is added and repository returns success',
    build: () {
      when(mockRepository.toggleLikeStatus(any))
          .thenAnswer((_) async => const Right(null));
      when(mockRepository.getLikedBooks())
          .thenAnswer((_) async => Right([tBook]));
      return bloc;
    },
    act: (bloc) => bloc.add(ToggleLike(book: tBook)),
    expect: () => [
      LikeUpdating(),
      BookLiked(isLiked: true),
    ],
  );

  blocTest<DetailBloc, DetailState>(
    'emits [LikeUpdating, DetailError] when ToggleLike is added and repository returns failure',
    build: () {
      when(mockRepository.toggleLikeStatus(any))
          .thenAnswer((_) async => Left(GenericFailure('error')));
      return bloc;
    },
    act: (bloc) => bloc.add(ToggleLike(book: tBook)),
    expect: () => [
      LikeUpdating(),
      isA<DetailError>(),
    ],
  );
}
