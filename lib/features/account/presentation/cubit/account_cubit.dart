import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/features/account/domain/repository/user_book_repository.dart';
import 'package:library_app/features/home/domain/entity/book_entity.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final BookUserRepository _repository;

  AccountCubit(this._repository) : super(AccountState());

  // Загрузка данных пользователя
  Future<void> loadUser(String userId) async {
    emit(UserLoading());
    try {
      final user = await _repository.getUserById(
        userId,
      ); // Загружаем пользователя
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Ошибка загрузки пользователя: $e'));
    }
  }

  // Аренда книги
  Future<void> rentBook(BookEntity book) async {
    if (state is! UserLoaded) {
      return;
    }
    final user = (state as UserLoaded).user;
    try {
      // Обновляем данные пользователя
      user.rentBook(book);
      // Обновляем данные в базе данных
      await _repository.updateUserBooks(user);
      // Обновляем состояние с новым пользователем
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Ошибка аренды книги: $e'));
    }
  }

  // Возврат книги
  Future<void> returnBook(BookEntity book) async {
    // Проверяем, что текущее состояние - UserLoaded
    if (state is! UserLoaded) {
      return;
    }

    final user = (state as UserLoaded).user;

    try {
      // Проверяем, что метод returnBook у пользователя существует и работает корректно
      user.returnBook(book);

      // Обновляем информацию о пользователе в репозитории
      await _repository.updateUserBooks(user);

      // Эмитируем новое состояние с обновлённым пользователем
      emit(UserLoaded(user));
    } catch (e) {
      // В случае ошибки передаем сообщение об ошибке в состоянии
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // Получение арендованных книг
  Future<void> fetchUserRentedBooks() async {
    if (state is! UserLoaded) {
      return;
    }

    final user = (state as UserLoaded).user;

    try {
      // Получаем арендованные книги пользователя
      final rentedBooks = await _repository.getUserRentedBooks(user);

      // Обновляем состояние с новыми арендованными книгами
      emit(UserLoaded(user.copyWith(rentedBooks: rentedBooks)));
    } catch (e) {
      emit(UserError('Ошибка получения арендованных книг: $e'));
    }
  }
}
