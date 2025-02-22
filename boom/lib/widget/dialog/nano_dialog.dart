import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

void nanoDialog(String title, message) {
  OneContext().showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
      );
    },
  );
}
