import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/core/constants/colors.dart';
import 'package:library_app/features/app/bloc/auth_bloc.dart';
import 'package:library_app/features/home/presentation/view/add_book.dart';
import 'package:library_app/features/home/presentation/view/books.dart';
import 'package:library_app/features/home/presentation/view/my_book.dart';
import 'package:library_app/features/utils/app_show.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeView> {
  int _selectedIndex = 0; // Индекс текущей страницы

  // Список страниц
  static final List<Widget> _pages = <Widget>[
    BookScreen(),
    const Center(child: Text('Мои книги', style: TextStyle(fontSize: 24))),
    RentedBooksScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Изменяем индекс при нажатии
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Список Книг'),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthenticatedState) {
                  return Text(state.user.email);
                }
                return const Text('');
              },
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddBookScreen()),
                        );
                      },
                    ),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is! AuthLoadingState) {
                          Navigator.pop(context);
                        }
                        if (state is AuthErrorState) {
                          AppShow.showError(context, state.message);
                        }
                        if (state is AuthLoadingState) {
                          AppShow.showLoading(context);
                        }
                        if (state is UnauthenticatedState) {
                          AppShow.navigateWellComeUntil(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthenticatedState) {
                          //return Text(state.user.email);
                          return IconButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthLogoutEvent());
                            },
                            icon: const Icon(Icons.exit_to_app),
                          );
                        } else {
                          return Text(' ');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Отображаем текущую страницу
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Книги',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Избранное'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Мои книги',
          ),
        ],
        currentIndex: _selectedIndex, // Указываем текущий индекс
        selectedItemColor: AppColors.blue, // Цвет выбранного элемента
        unselectedItemColor: AppColors.grey, // Цвет невыбранных элементов
        onTap: _onItemTapped, // Обработчик нажатий
      ),
    );
  }
}
