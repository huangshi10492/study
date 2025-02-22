import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';

void copyDialog(String title, message) {
  OneContext().showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('复制'),
            onPressed: () {
              // 复制代码
              Clipboard.setData(ClipboardData(text: message));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('内容已复制到剪贴板'),
                  duration: Duration(seconds: 1),
                ),
              );
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('确认'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
