import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/features/app/bloc/auth_bloc.dart';
import 'package:library_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:library_app/features/welcome/view/welcome_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.storage});

  final SharedPreferences storage;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            auth: FirebaseAuth.instance,
            storage: storage,
            db: FirebaseFirestore.instance,
          )..add(AuthInitialEvent()),
        ),
        BlocProvider(
          create: (context) => HomeCubit(FirebaseFirestore.instance),
        ),
      ],
      child: MaterialApp(
        title: 'My books',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
          useMaterial3: true,
        ),
        home: const WellComeView(),
      ),
    );
  }
}
