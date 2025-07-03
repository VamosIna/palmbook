import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository_impl.dart';
import 'package:com_palmcode_book/features/liked/data/datasources/local/liked_local_data_source.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';

import 'liked_repository_test.mocks.dart';

@GenerateMocks([LikedLocalDataSource])
void main() {
  late LikedRepositoryImpl repository;
  late MockLikedLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockLikedLocalDataSource();
    repository = LikedRepositoryImpl(localDataSource: mockDataSource);
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

  test('should return Right(List<Book>) when local data source returns books', () async {
    when(mockDataSource.getLikedBooks()).thenAnswer((_) async => tBooks);

    final result = await repository.getLikedBooks();

    expect(result, Right(tBooks));
  });

  test('should return Left(CacheFailure) when local data source throws CacheException', () async {
    when(mockDataSource.getLikedBooks()).thenThrow(CacheException(message: 'Cache error'));

    final result = await repository.getLikedBooks();

    expect(result, Left(CacheFailure('Cache error')));
  });

  test('should add book if not liked and return Right(void) on toggleLikeStatus', () async {
    when(mockDataSource.getLikedBooks()).thenAnswer((_) async => []);
    when(mockDataSource.addLikedBook(any)).thenAnswer((_) async => {});

    final result = await repository.toggleLikeStatus(tBooks[0]);

    expect(result, const Right(null));
    verify(mockDataSource.addLikedBook(tBooks[0])).called(1);
  });

  test('should remove book if already liked and return Right(void) on toggleLikeStatus', () async {
    when(mockDataSource.getLikedBooks()).thenAnswer((_) async => tBooks);
    when(mockDataSource.removeLikedBook(any)).thenAnswer((_) async => {});

    final result = await repository.toggleLikeStatus(tBooks[0]);

    expect(result, const Right(null));
    verify(mockDataSource.removeLikedBook(tBooks[0].id)).called(1);
  });

  test('should return Left(CacheFailure) when local data source throws CacheException on toggleLikeStatus', () async {
    when(mockDataSource.getLikedBooks()).thenThrow(CacheException(message: 'Cache error'));

    final result = await repository.toggleLikeStatus(tBooks[0]);

    expect(result, Left(CacheFailure('Cache error')));
  });
}
