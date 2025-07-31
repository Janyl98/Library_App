import 'package:flutter/material.dart';
import 'package:library_app/features/home/presentation/view/home_view.dart';
import 'package:library_app/features/welcome/welcome.dart';

class AppShow {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: SizedBox(
          height: 35,
          width: 35,
          child: FittedBox(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  static void navigateHomeUntil(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeView()),
      (Route route) => false,
    );
  }

  static void navigateWellComeUntil(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WellComeView()),
      (Route route) => false,
    );
  }

  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
