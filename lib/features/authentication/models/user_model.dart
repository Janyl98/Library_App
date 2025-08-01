import 'package:library_app/features/home/domain/entity/book_entity.dart';

class User {
  final String email;
  final String password;
  final String uid;
  final bool isGroup;
  final List<BookEntity> rentedBooks;

  // Конструктор
  User({
    required this.email,
    required this.password,
    required this.uid,
    this.isGroup = false,
    List<BookEntity>? rentedBooks, // Параметр может быть null
  }) : rentedBooks =
           rentedBooks ??
           []; // Если rentedBooks == null, то присваиваем пустой список

  // Метод copyWith для обновления rentedBooks
  User copyWith({List<BookEntity>? rentedBooks}) {
    return User(
      uid: this.uid,
      rentedBooks: rentedBooks ?? this.rentedBooks,
      email: this.email,
      password: this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'uid': uid,
      'isGroup': isGroup,
      'rentedBooks': rentedBooks
          .map((book) => book.toFirestore())
          .toList(), // Преобразуем книги в JSON
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      password: map['password'] as String,
      uid: map['uid'] as String,
      isGroup: map['isGroup'] as bool,
      rentedBooks:
          (map['rentedBooks'] as List<dynamic>?)
              ?.map((bookData) {
                if (bookData is Map<String, dynamic>) {
                  return BookEntity.fromJson(
                    bookData,
                  ); // Преобразуем Map в объект Book через fromJson
                } else {
                  return null; // Если это не карта, пропускаем
                }
              })
              .where((book) => book != null) // Убираем возможные null значения
              .cast<
                BookEntity
              >() // Преобразуем в List<Book>, устранив null элементы
              .toList() ??
          [], // Если rentedBooks == null, возвращаем пустой список
    );
  }

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

  void returnBook(BookEntity book) {
    // Ищем книгу по ID в списке
    final rentedBook = rentedBooks.firstWhere((b) => b.id == book.id);

    // ignore: unnecessary_null_comparison
    if (rentedBook == null) {
      print("Book '${book.gettitle}' is not rented by this user.");
      return;
    }

    // Удаляем книгу из списка и выполняем действия по возврату
    rentedBooks.remove(rentedBook);
    book.returnBook();
    print("Book '${rentedBook.gettitle}' returned successfully.");
  }
}
