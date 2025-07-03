import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:com_palmcode_book/features/book/data/repositories/book_repository_impl.dart';
import 'package:com_palmcode_book/features/book/data/datasources/remote/book_remote_data_source.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:com_palmcode_book/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';

import 'book_repository_test.mocks.dart';

@GenerateMocks([BookRemoteDataSource])
void main() {
  late BookRepositoryImpl repository;
  late MockBookRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockBookRemoteDataSource();
    repository = BookRepositoryImpl(remoteDataSource: mockDataSource);
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

  test('should return Right(List<Book>) when remote data source returns books', () async {
    when(mockDataSource.getBooks(page: anyNamed('page'), query: anyNamed('query')))
        .thenAnswer((_) async => tBooks);

    final result = await repository.getBooks(page: 1, query: '');

    expect(result, Right(tBooks));
  });

  test('should return Left(ServerFailure) when remote data source throws ServerException', () async {
    when(mockDataSource.getBooks(page: anyNamed('page'), query: anyNamed('query')))
        .thenThrow(ServerException(message: 'Server error'));

    final result = await repository.getBooks(page: 1, query: '');

    expect(result, Left(ServerFailure('Server error')));
  });
}
