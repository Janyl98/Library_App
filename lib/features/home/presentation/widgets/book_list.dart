import 'package:flutter/material.dart';
import 'package:library_app/features/home/domain/entity/book_entity.dart';

import 'book_list_item.dart';

class BookList extends StatelessWidget {
  final List<BookEntity> books;
  final ValueChanged<BookEntity> onBookSelected;

  const BookList({Key? key, required this.books, required this.onBookSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookListItem(book: book, onTap: () => onBookSelected(book));
        },
      ),
    );
  }
}
