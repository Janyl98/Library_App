import 'package:bloc/bloc.dart';
import 'package:library_app/features/account/domain/repository/user_book_repository.dart';
import 'package:library_app/features/account/presentation/cubit/user_state.dart';
import 'package:library_app/features/home/domain/entity/book_entity.dart';

// Cubit для управления состоянием
class UserCubit extends Cubit<UserState> {
  final BookUserRepository bookRepository;
  List<BookEntity> rentedBooks = [];

  UserCubit(this.bookRepository) : super(BookInitialState());

  // Метод аренды книги
  Future<void> rentBook(BookEntity book) async {
    try {
      await bookRepository.rentBook(book);
      rentedBooks.add(book);
      emit(BookRentedState(rentedBooks));
    } catch (e) {
      print('Error renting book: $e');
    }
  }

  // Метод возврата книги
  Future<void> returnBook(BookEntity book) async {
    try {
      await bookRepository.returnBook(book);
      rentedBooks.remove(book);
      emit(BookRentedState(rentedBooks));
    } catch (e) {
      print('Error returning book: $e');
    }
  }

  // Получение доступных книг
  Future<void> fetchBooks() async {
    try {
      final books = await bookRepository.getAvailableBooks();
      emit(BookRentedState(books));
    } catch (e) {
      print('Error fetching books: $e');
    }
  }
}
