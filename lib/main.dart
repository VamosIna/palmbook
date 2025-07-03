import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:com_palmcode_book/features/detail/presentation/screens/detail_screen.dart';
import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository.dart';
import 'package:flutter/material.dart';
import 'package:com_palmcode_book/app.dart';
import 'package:com_palmcode_book/injection_container.dart' as di;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Tambahkan provider untuk LikedRepository
      providers: [
        Provider<LikedRepository>(create: (_) => di.sl<LikedRepository>()),
      ],
      child: MaterialApp(
        title: 'Book App',
        checkerboardOffscreenLayers: false,
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: App(),
        routes: {
          '/detail': (context) {
            final book = ModalRoute.of(context)!.settings.arguments as Book;
            return DetailScreen(book: book);
          },
        },
      ),
    );
  }
}
