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
          actions: const [
            SizedBox(),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 200,
                  height: 300,
                  child: Stack(
                    children: [
                      book.coverUrl != null
                          ? CachedNetworkImage(
                              imageUrl: book.coverUrl!,
                              height: 300,
                              width: 200,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Container(
                                height: 300,
                                width: 200,
                                color: Colors.grey[200],
                                child: const Icon(Icons.book, size: 100),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 300,
                                width: 200,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                ),
                              ),
                            )
                          : Container(
                              height: 300,
                              width: 200,
                              color: Colors.grey[200],
                              child: const Icon(Icons.book, size: 100),
                            ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: BlocBuilder<DetailBloc, DetailState>(
                          builder: (context, state) {
                            if (state is LikeUpdating) {
                              return const SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              );
                            }
                            if (state is BookLiked) {
                              return Container(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  icon: Icon(
                                    state.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: state.isLiked
                                        ? AppColors.danger
                                        : AppColors.primary,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<DetailBloc>()
                                        .add(ToggleLike(book: book));
                                  },
                                  iconSize: 32,
                                  splashRadius: 24,
                                  tooltip: state.isLiked
                                      ? 'Unlike'
                                      : 'Like',
                                ),
                              );
                            }
                            return const SizedBox(width: 40, height: 40);
                          },
                        ),
                      ),
                    ],
                  ),
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
