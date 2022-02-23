import 'dart:math';

import 'package:africhange/constants/custom_colors.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

class CChart {
  static Widget days90() {
    Random _rand = Random();
    List<double> _data =
        List.generate(90, (index) => (50.0 + (_rand.nextDouble() * 3)));
    return Sparkline(
      data: _data,
      fillMode: FillMode.below,
      min: 0,
      max: 55,
      fillGradient: CColor.chartGrad,
    );
  }

  static Widget days30() {
    Random _rand = Random();
    List<double> _data =
        List.generate(30, (index) => (50.0 + (_rand.nextDouble() * 3)));
    return Sparkline(
      data: _data,
      fillMode: FillMode.below,
      min: 0,
      max: 55,
      fillGradient: CColor.chartGrad,
    );
  }
}
