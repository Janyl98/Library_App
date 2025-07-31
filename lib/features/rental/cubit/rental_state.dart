import 'package:library_app/features/rental/domain/entity/rental_entity.dart';

abstract class RentalState {}

class RentalInitial extends RentalState {}

class RentalLoading extends RentalState {}

class RentalSuccess extends RentalState {
  final RentalEntity rental;

  RentalSuccess({required this.rental});
}

class RentalError extends RentalState {
  final String message;

  RentalError({required this.message});
}

class RentalListLoaded extends RentalState {
  final List<RentalEntity> rentals;

  RentalListLoaded({required this.rentals});
}
