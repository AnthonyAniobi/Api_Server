import 'package:africhange/constants/custom_colors.dart';
import 'package:africhange/constants/custom_fonts.dart';
import 'package:flutter/material.dart';

class CDialog {
  static void error(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              width: 450,
              height: 250,
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel))
                ]),
                CFont.big(text: 'Error', color: CColor.blueDark),
                const SizedBox(height: 20),
                CFont.regular(
                    text: 'You cant set a user profile from a basic account',
                    color: CColor.grey),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: CFont.regular(text: 'Close', color: CColor.white)),
                  const SizedBox(width: 10),
                ]),
              ]),
            ),
          );
        });
  }
}
