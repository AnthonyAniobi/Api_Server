import 'package:flutter/material.dart';

class Dialogs {
  static Future<bool> warning(BuildContext context,
      {required String title, required String message}) async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(title),
                icon: const Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                content: Text(message),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes')),
                ],
              );
            }) ??
        false;
  }
}
