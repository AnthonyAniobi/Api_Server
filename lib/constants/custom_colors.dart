import 'package:flutter/material.dart';

class CColor {
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color grey = Color(0xff838484);
  static const Color lightGrey = Color(0xfffafafa);
  static const Color lightBlue = Color(0xff05dc9c);
  static const Color blueDark = Color(0xff0060d0);
  static const Color blueNorm = Color(0xff0175ff);
  static const Color blueWhite1 = Color(0xff54a3ff);
  static const Color blueWhite2 = Color(0xff0779ff);

  static const LinearGradient gradient = LinearGradient(
    colors: [CColor.blueDark, CColor.blueNorm],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static List<BoxShadow> shadow = [
    BoxShadow(
        color: CColor.black.withOpacity(0.16),
        offset: const Offset(3, 3),
        blurRadius: 6),
  ];

  static const LinearGradient chartGrad = LinearGradient(
    colors: [CColor.blueWhite1, CColor.blueWhite2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
