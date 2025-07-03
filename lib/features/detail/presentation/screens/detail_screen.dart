import 'package:com_palmcode_book/features/liked/data/repositories/liked_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_palmcode_book/core/constants/colors.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';
import 'package:com_palmcode_book/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:com_palmcode_book/injection_container.dart' as di;

class DetailScreen extends StatelessWidget {
  final Book book;

  const DetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              DetailBloc(likedRepository: di.sl<LikedRepository>())
                ..add(CheckIfLiked(bookId: book.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(book.title),
          actions: [
            BlocBuilder<DetailBloc, DetailState>(
              builder: (context, state) {
                if (state is LikeUpdating) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is BookLiked) {
                  return IconButton(
                    icon: Icon(
                      state.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: state.isLiked ? AppColors.primary : null,
                    ),
                    onPressed: () {
                      context.read<DetailBloc>().add(ToggleLike(book: book));
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child:
                    book.coverUrl != null
                        ? CachedNetworkImage(
                          imageUrl: book.coverUrl!,
                          height: 300,
                          fit: BoxFit.contain,
                          placeholder:
                              (context, url) => Container(
                                height: 300,
                                color: Colors.grey[200],
                                child: const Icon(Icons.book, size: 100),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                height: 300,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                ),
                              ),
                        )
                        : Container(
                          height: 300,
                          color: Colors.grey[200],
                          child: const Icon(Icons.book, size: 100),
                        ),
              ),
              const SizedBox(height: 20),
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'By: ${book.authors.join(', ')}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.download, color: Colors.green),
                  const SizedBox(width: 5),
                  Text(
                    '${book.downloadCount} downloads',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                book.subjects.isNotEmpty
                    ? book.subjects.join('\n\n')
                    : 'No description available',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
