import 'package:library_app/features/home/domain/entity/book_entity.dart';

class User {
  String name;
  int id;
  List<BookEntity> rentedBooks = [];

  // Конструктор
  User({required this.name, required this.id});

  // Метод: Китепти ижарага алуу
  void rentBook(BookEntity book) {
    if (book.copyCount > 0) {
      rentedBooks.add(book);
      book.rentBook();
      print("Book '${book.gettitle}' rented successfully.");
    } else {
      print("Book '${book.gettitle}' is not available.");
    }
  }

  // Метод: Китепти кайтаруу
  void returnBook(BookEntity book) {
    if (rentedBooks.contains(book.gettitle)) {
      rentedBooks.remove(book.gettitle);
      book.returnBook();
      print("Book '${book.gettitle}' returned successfully.");
    } else {
      print("Book '${book.gettitle}' is not rented by this user.");
    }
  }
}
