import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:com_palmcode_book/core/widgets/book_card.dart';
import 'package:com_palmcode_book/core/widgets/error_widget.dart';
import 'package:com_palmcode_book/features/liked/presentation/bloc/liked_bloc.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikedBloc, LikedState>(
      builder: (context, state) {
        if (state is LikedInitial || state is LikedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LikedLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<LikedBloc>().add(LoadLikedBooks());
            },
            child:
                state.books.isEmpty
                    ? const Center(child: Text('No liked books'))
                    : ListView.builder(
                      itemCount: state.books.length,
                      itemBuilder: (context, index) {
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
                    ),
          );
        } else if (state is LikedError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context.read<LikedBloc>().add(LoadLikedBooks()),
          );
        }
        return Container();
      },
    );
  }
}
