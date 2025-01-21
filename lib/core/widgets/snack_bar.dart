import 'package:flutter/material.dart';

Future<void> snackBar(BuildContext context, String message, Color color) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}
