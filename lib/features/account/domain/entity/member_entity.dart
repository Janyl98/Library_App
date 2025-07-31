import 'package:library_app/features/account/domain/entity/user_entity.dart';
import 'package:library_app/features/home/domain/entity/book_entity.dart';

class MemberEntity extends User {
  MemberEntity({
    required String name,
    required String id,
    List<BookEntity> rentedBooks = const [],
  }) : super(name: name, id: id, rentedBooks: rentedBooks);

  // Метод для возврата книги
  void returnBook(BookEntity book) {
    rentedBooks.remove(book);
  }
}
