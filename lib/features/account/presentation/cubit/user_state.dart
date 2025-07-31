// Состояния Cubit
import 'package:equatable/equatable.dart';
import 'package:library_app/features/home/domain/entity/book_entity.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitialState extends UserState {}

class BookRentedState extends UserState {
  final List<BookEntity> rentedBooks;

  BookRentedState(this.rentedBooks);

  @override
  List<Object?> get props => [rentedBooks];
}

// События Cubit
abstract class BookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RentBookEvent extends BookEvent {
  final BookEntity book;

  RentBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}

class ReturnBookEvent extends BookEvent {
  final BookEntity book;

  ReturnBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}
