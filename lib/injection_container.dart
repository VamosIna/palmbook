import 'package:com_palmcode_book/features/book/data/repositories/book_repository.dart';
import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/book/data/datasources/remote/book_remote_data_source.dart';
import 'features/book/data/datasources/remote/book_remote_data_source_impl.dart';
import 'features/book/data/repositories/book_repository_impl.dart';
import 'features/book/presentation/bloc/book_bloc.dart';
import 'features/liked/data/datasources/local/liked_local_data_source.dart';
import 'features/liked/data/datasources/local/liked_local_data_source_impl.dart';
import 'features/liked/data/repositories/liked_repository_impl.dart';
import 'features/liked/presentation/bloc/liked_bloc.dart';
import 'features/detail/presentation/bloc/detail_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // External dependencies
  sl.registerSingleton<http.Client>(http.Client());

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data sources
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<LikedLocalDataSource>(
    () => LikedLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<LikedRepository>(
    () => LikedRepositoryImpl(localDataSource: sl()),
  );

  // BLoCs
  sl.registerFactory(() => BookBloc(repository: sl()));
  sl.registerLazySingleton(() => LikedBloc(repository: sl()));
  sl.registerFactory(() => DetailBloc(likedRepository: sl()));
}
