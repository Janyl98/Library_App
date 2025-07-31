import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:library_app/core/constants/colors.dart';
import 'package:library_app/features/account/domain/repository/user_book_repository.dart';
import 'package:library_app/features/account/presentation/cubit/account_cubit.dart';
import 'package:library_app/features/account/presentation/cubit/account_state.dart';
import 'package:library_app/features/home/domain/repository/book_repository.dart';
import 'package:library_app/features/home/presentation/cubit/book_cubit.dart';
import 'package:library_app/features/rental/cubit/rental_cubit.dart';
import 'package:library_app/features/rental/cubit/rental_state.dart';
import 'package:library_app/features/rental/domain/repository/repository.dart';

class RentedBooksScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid;
  }

  // Форматирование даты
  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final userId = getCurrentUserId();
    return MultiBlocProvider(
      providers: [
        BlocProvider<RentalCubit>(
          create: (context) => RentalCubit(
            RentalRepository(FirebaseFirestore.instance),
            FirebaseBookRepository(FirebaseFirestore.instance),
          )..fetchRentalsByUserId(userId!),
        ),
        BlocProvider<BookCubit>(
          create: (context) => BookCubit(
            bookRepository: FirebaseBookRepository(FirebaseFirestore.instance),
          )..loadBooks(),
        ),
        BlocProvider<AccountCubit>(
          create: (context) =>
              AccountCubit(BookUserRepository())..loadUser(getCurrentUserId()!),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<RentalCubit, RentalState>(
          builder: (context, state) {
            if (state is RentalLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RentalError) {
              return Center(child: Text("Ошибка: ${state.message}"));
            }

            if (state is RentalListLoaded) {
              if (state.rentals.isEmpty) {
                return const Center(child: Text("Нет активных аренд."));
              }

              return ListView.builder(
                itemCount: state.rentals.length,
                itemBuilder: (context, index) {
                  final rental = state.rentals[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(rental.bookTitle),
                        subtitle: Text(
                          "Дата возврата: ${formatDate(rental.dueDate)}",
                          style: const TextStyle(color: AppColors.blue),
                        ),
                      ),
                      BlocBuilder<AccountCubit, AccountState>(
                        builder: (context, state) {
                          return TextButton(
                            onPressed: () async {
                              final book = await FirebaseBookRepository(
                                FirebaseFirestore.instance,
                              ).getBookById(rental.bookId);
                              final rentalCubit = context.read<RentalCubit>();
                              final userCubit = context.read<AccountCubit>();
                              final bookCubit = context.read<BookCubit>();
                              rentalCubit.returnBook(rental);
                              userCubit.returnBook(book);
                              bookCubit.returnBook(book);
                            },
                            child: const Text(
                              'Возврать книгу',
                              style: TextStyle(color: AppColors.red),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            }

            // Заглушка на случай состояния RentalInitial или других
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
