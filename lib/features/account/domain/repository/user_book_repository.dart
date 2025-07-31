import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/features/authentication/models/user_model.dart';
import 'package:library_app/features/home/domain/entity/book_entity.dart';

class BookUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Метод для получения доступных книг
  Future<List<BookEntity>> getAvailableBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      return snapshot.docs.where((doc) => doc['copyCount'] > 0).map((doc) {
        return BookEntity(
          id: doc.id,
          title: doc['title'] ?? '',
          author: doc['author'] ?? '',
          date: doc['date'] ?? '',
          genres: doc['genres'] ?? '',
          copyCount: doc['copyCount'] ?? '',
          isAvailable: doc['isAvailable'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception("Error fetching books: $e");
    }
  }

  // Метод для аренды книги
  Future<void> rentBook(BookEntity book) async {
    try {
      final docRef = _firestore.collection('books').doc(book.id.toString());
      final doc = await docRef.get();
      if (doc.exists && doc['copyCount'] > 0) {
        await docRef.update({'copyCount': doc['copyCount'] - 1});
      }
    } catch (e) {
      throw Exception("Error renting book: $e");
    }
  }

  // Метод для возврата книги
  Future<void> returnBook(BookEntity book) async {
    try {
      final docRef = _firestore.collection('books').doc(book.id.toString());
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({'copyCount': doc['copyCount'] + 1});
      }
    } catch (e) {
      throw Exception("Error returning book: $e");
    }
  }

  // Сохранение данных пользователя в Firebase
  Future<void> saveUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.email,
        'id': user.uid,
        'rentedBooks': user.rentedBooks
            .map((book) => (book).toFirestore())
            .toList(),
      });
    } catch (e) {
      throw Exception('Error saving user: $e');
    }
  }

  // Загрузка данных пользователя из Firebase
  Future<User?> loadUser(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id.toString()).get();
      if (doc.exists) {
        final data = doc.data()!;
        return User(
          email: data['email'],
          uid: data['uid'],
          rentedBooks: (data['rentedBooks'] as List)
              .map((bookData) => BookEntity.fromFirestore(bookData))
              .toList(),
          password: data['password'],
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error loading user: $e');
    }
  }

  Future<User> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) {
      throw Exception('Пользователь не найден');
    }
    return User.fromJson(doc.data()!);
  }

  Future<void> updateUserBooks(User user) async {
    try {
      print(
        'New rentedBooks: ${user.rentedBooks.map((book) => (book).toFirestore()).toList()}',
      );
      await _firestore.collection('users').doc(user.uid).update({
        'rentedBooks': user.rentedBooks
            .map((book) => (book).toFirestore())
            .toList(),
        'isGroup': true,
      });
      print('Firestore updated successfully.');
    } catch (e) {
      print('Error updating Firestore: $e');
      throw Exception('Error updating user books: $e');
    }
  }

  Future<List<BookEntity>> getUserRentedBooks(User user) async {
    try {
      // Получаем документ пользователя по его uid
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // Извлекаем поле 'rentedBooks' и преобразуем его в список объектов Book
        final rentedBooksData =
            userDoc.data()?['rentedBooks'] as List<dynamic>? ?? [];
        List<BookEntity> rentedBooks = rentedBooksData
            .map((bookData) => BookEntity.fromFirestore(bookData))
            .toList();

        print('Книги успешно получены.');
        return rentedBooks;
      } else {
        print('Пользователь не найден.');
        return [];
      }
    } catch (e) {
      print('Ошибка при получении книг: $e');
      throw Exception('Ошибка при получении книг пользователя: $e');
    }
  }
}
