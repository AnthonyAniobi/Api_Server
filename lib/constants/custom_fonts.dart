import 'package:africhange/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class CFont {
  static Widget small(
      {required String text,
      Color color = CColor.black,
      TextDecoration underline = TextDecoration.none}) {
    return Text(
      text,
      style: TextStyle(
          decoration: underline,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: color),
    );
  }

  static Widget regular({required String text, Color color = CColor.black}) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }

  static Widget big({required String text, Color color = CColor.black}) {
    return Text(
      text,
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: color),
    );
  }
}
