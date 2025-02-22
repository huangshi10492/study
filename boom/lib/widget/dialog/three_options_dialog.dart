import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

Future<bool?> threeOptionsDialog(
  String title,
  message,
  okText,
  cancelText,
  nullText,
) async {
  return await OneContext().showDialog<bool>(
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text(nullText)),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(cancelText)),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(okText),
          ),
        ],
      );
    },
  );
}
