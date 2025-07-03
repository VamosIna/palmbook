import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:com_palmcode_book/core/widgets/book_card.dart';
import 'package:com_palmcode_book/core/widgets/error_widget.dart';
import 'package:com_palmcode_book/features/book/presentation/bloc/book_bloc.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  late BookBloc _bookBloc;

  @override
  void initState() {
    super.initState();
    _bookBloc = context.read<BookBloc>();
    _scrollController.addListener(_onScroll);
    _bookBloc.add(FetchBooks(isInitial: true));
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _bookBloc.add(FetchBooks());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search books...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _bookBloc.add(SearchBooks(query: _searchController.text));
              },
            ),
          ),
          onSubmitted: (value) {
            _bookBloc.add(SearchBooks(query: value));
          },
        ),
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookInitial || state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookLoaded) {
            return state.books.isEmpty
                ? const Center(child: Text('No books found'))
                : ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      state.hasReachedMax
                          ? state.books.length
                          : state.books.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.books.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return BookCard(
                      book: state.books[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: state.books[index],
                        );
                      },
                    );
                  },
                );
          } else if (state is BookEmpty) {
            return const Center(child: Text('No books available'));
          } else if (state is BookError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => _bookBloc.add(FetchBooks(isInitial: true)),
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
