import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/features/account/domain/entity/user_entity.dart';
import 'package:library_app/features/home/models/book.dart';

class AdminEntity extends User {
  AdminEntity({required String name, required String id})
    : super(name: name, id: id);

  // Метод для добавления книги
  Future<void> addBookToLibrary(
    Book book,
    CollectionReference libraryRef,
  ) async {
    await libraryRef.add(book.toFirestore());
  }

  // Метод для удаления книги из из коллекции books в Firestore
  Future<void> removeBookFromLibrary(
    String bookId,
    CollectionReference libraryRef,
  ) async {
    final query = await libraryRef.where('id', isEqualTo: bookId).get();
    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }

  // Метод для удаления аренды из коллекции rentals в Firestore
  Future<void> removeRentalFromFirestore(
    String rentalId,
    CollectionReference rentalsRef,
  ) async {
    try {
      final rentalDoc = await rentalsRef.doc(rentalId).get();
      if (rentalDoc.exists) {
        await rentalDoc.reference.delete();
      } else {
        print('Аренда с ID $rentalId не найдена.');
      }
    } catch (e) {
      print('Ошибка при удалении аренды: $e');
    }
  }
}
