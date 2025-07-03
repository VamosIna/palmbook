import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:com_palmcode_book/features/liked/presentation/bloc/liked_bloc.dart';
import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:dartz/dartz.dart';
import 'package:com_palmcode_book/core/errors/exceptions.dart';

import 'liked_bloc_test.mocks.dart';

@GenerateMocks([LikedRepository])
void main() {
  late LikedBloc bloc;
  late MockLikedRepository mockRepository;

  setUp(() {
    mockRepository = MockLikedRepository();
    bloc = LikedBloc(repository: mockRepository);
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

  blocTest<LikedBloc, LikedState>(
    'emits [LikedLoading, LikedLoaded] when LoadLikedBooks is added and repository returns books',
    build: () {
      when(mockRepository.getLikedBooks())
          .thenAnswer((_) async => Right(tBooks));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadLikedBooks()),
    expect: () => [
      LikedLoading(),
      LikedLoaded(books: tBooks),
    ],
  );

  blocTest<LikedBloc, LikedState>(
    'emits [LikedLoading, LikedLoaded] when LoadLikedBooks is added and repository returns empty list',
    build: () {
      when(mockRepository.getLikedBooks())
          .thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadLikedBooks()),
    expect: () => [
      LikedLoading(),
      LikedLoaded(books: []),
    ],
  );

  blocTest<LikedBloc, LikedState>(
    'emits [LikedLoading, LikedError] when LoadLikedBooks is added and repository returns failure',
    build: () {
      when(mockRepository.getLikedBooks())
          .thenAnswer((_) async => Left(GenericFailure('error')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadLikedBooks()),
    expect: () => [
      LikedLoading(),
      isA<LikedError>(),
    ],
  );
}
