import 'package:africhange/constants/custom_colors.dart';
import 'package:africhange/constants/custom_fonts.dart';
import 'package:flutter/material.dart';

class CForms {
  static Widget text(
      {required TextEditingController controller,
      required String label,
      bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
      decoration: BoxDecoration(
          color: CColor.lightGrey, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                  color: CColor.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              enabled: enabled,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          CFont.regular(text: label, color: CColor.grey),
        ],
      ),
    );
  }
}
