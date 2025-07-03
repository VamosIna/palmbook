import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:com_palmcode_book/features/book/presentation/bloc/book_bloc.dart';
import 'package:com_palmcode_book/features/book/data/repositories/book_repository.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:dartz/dartz.dart';
import 'package:com_palmcode_book/core/errors/exceptions.dart';

import 'book_bloc_test.mocks.dart';

@GenerateMocks([BookRepository])
void main() {
  late BookBloc bloc;
  late MockBookRepository mockRepository;

  setUp(() {
    mockRepository = MockBookRepository();
    bloc = BookBloc(repository: mockRepository);
  });

  final tBooks = [
    Book(
      id: 1,
      title: 'Test',
      authors: ['Author'],
      coverUrl: 'https://example.com/cover.jpg',
      downloadCount: 10,
      subjects: ['Fiction'],
    )
  ];

  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookLoaded] when FetchBooks is added and repository returns books',
    build: () {
      when(mockRepository.getBooks(page: anyNamed('page'), query: anyNamed('query')))
          .thenAnswer((_) async => Right(tBooks));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchBooks(isInitial: true)),
    expect: () => [
      BookLoading(),
      BookLoaded(books: tBooks, hasReachedMax: false),
    ],
  );

  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookEmpty] when FetchBooks is added and repository returns empty list',
    build: () {
      when(mockRepository.getBooks(page: anyNamed('page'), query: anyNamed('query')))
          .thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchBooks(isInitial: true)),
    expect: () => [
      BookLoading(),
      BookEmpty(),
    ],
  );

  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookError] when FetchBooks is added and repository returns failure',
    build: () {
      when(mockRepository.getBooks(page: anyNamed('page'), query: anyNamed('query')))
          .thenAnswer((_) async => Left(GenericFailure('error')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchBooks(isInitial: true)),
    expect: () => [
      BookLoading(),
      isA<BookError>(),
    ],
  );
}
