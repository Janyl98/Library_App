import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/features/home/domain/entity/book_entity.dart';
import 'dart:async';

// Класс Rental (Аренда)
class RentalEntity {
  final String? id; // ID аренды
  final String bookId; // Арендуемая книга
  final String userId; // ID пользователя
  final DateTime rentalDate; // Дата начала аренды
  final String bookTitle;
  final DateTime dueDate; // Дата окончания аренды
  DateTime? returnDate; // Дата возврата книги
  final String userName;

  // Конструктор
  RentalEntity({
    this.id,
    required this.bookId,
    required this.userName,
    required this.userId,
    required this.rentalDate,
    required this.dueDate,
    this.returnDate,
    required this.bookTitle,
  });

  // Метод для создания аренды
  static Future<RentalEntity?> createRental({
    required String bookId,
    required String userId,
    required String bookTitle,
    required String userName,
    required int rentalPeriodDays,
  }) async {
    // Создаем объект Rental
    final rental = RentalEntity(
      userName: userName,
      bookId: bookId,
      userId: userId,
      bookTitle: bookTitle,
      rentalDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: rentalPeriodDays)),
    );

    // Сохраняем аренду в Firestore
    try {
      final doc = await FirebaseFirestore.instance.collection('rentals').add({
        'bookId': bookId,
        'userId': userId,
        'userName': userName,
        'bookTitle': bookTitle,
        'rentalDate': rental.rentalDate.toIso8601String(),
        'dueDate': rental.dueDate.toIso8601String(),
        'returnDate': null,
      });

      return rental.copyWith(id: doc.id);
    } catch (e) {
      print("Ошибка при создании аренды: $e");
      return null;
    }
  }

  factory RentalEntity.fromMap(Map<String, dynamic> map) {
    print("Парсинг Rental: $map"); // Лог данных
    try {
      return RentalEntity(
        id: map['id'] as String? ?? '',
        bookId: map['bookId'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        userName: map['userName'] as String? ?? '',
        bookTitle: map['bookTitle'] as String? ?? '',
        rentalDate: map['rentalDate'] != null
            ? DateTime.tryParse(map['rentalDate']) ?? DateTime.now()
            : DateTime.now(),
        dueDate: map['dueDate'] != null
            ? DateTime.tryParse(map['dueDate']) ?? DateTime.now()
            : DateTime.now(),
        returnDate: map['returnDate'] != null
            ? DateTime.tryParse(map['returnDate'])
            : null,
      );
    } catch (e) {
      print('Ошибка: $e');
      throw Exception('Error parsing Rental from map: $e');
    }
  }

  // Преобразование объекта Rental в Map для сохранения в Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'userId': userId,
      'bookTitle': bookTitle,
      'userName': userName, // Исправлено
      'rentalDate': rentalDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
    };
  }

  // Метод для копирования Rental с изменением параметров
  RentalEntity copyWith({
    String? id,
    BookEntity? book,
    String? userId,
    String? bookTitle,
    DateTime? rentalDate,
    DateTime? dueDate,
    DateTime? returnDate,
  }) {
    return RentalEntity(
      id: id ?? this.id,
      bookId: this.bookId,
      userName: this.userName,
      bookTitle: this.bookTitle,
      userId: userId ?? this.userId,
      rentalDate: rentalDate ?? this.rentalDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
    );
  }
}
