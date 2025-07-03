import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_palmcode_book/features/book/domain/entities/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({Key? key, required this.book, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (book.coverUrl != null)
                CachedNetworkImage(
                  imageUrl: book.coverUrl!,
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.book, size: 40),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                )
              else
                Container(
                  width: 70,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.book, size: 40),
                ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.authors.join(', '),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.download,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${book.downloadCount} downloads',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
