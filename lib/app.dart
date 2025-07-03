import 'package:com_palmcode_book/features/book/presentation/bloc/book_bloc.dart';
import 'package:com_palmcode_book/features/liked/presentation/bloc/liked_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:com_palmcode_book/core/widgets/bottom_nav_bar.dart';
import 'package:com_palmcode_book/features/book/presentation/screens/home_screen.dart';
import 'package:com_palmcode_book/features/liked/presentation/screens/liked_screen.dart';
import 'package:com_palmcode_book/injection_container.dart' as di;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<BookBloc>()),
        // Pastikan LikedBloc di-provide di sini
        BlocProvider(
          create: (context) => di.sl<LikedBloc>()..add(LoadLikedBooks()),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [HomeScreen(), LikedScreen()],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
