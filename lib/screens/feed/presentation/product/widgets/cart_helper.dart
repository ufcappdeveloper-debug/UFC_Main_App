import 'dart:ui';

import 'package:flutter/material.dart';

class CartHelper{
  void showConfirmationDialog({required String message, required VoidCallback onConfirm,required BuildContext context}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // close dialog
                onConfirm();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void showSuccessSnackbar(String message,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }



}
CartHelper cartHelper=CartHelper();