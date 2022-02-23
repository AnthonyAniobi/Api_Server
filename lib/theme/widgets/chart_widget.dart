import 'package:africhange/constants/custom_colors.dart';
import 'package:africhange/constants/custom_fonts.dart';
import 'package:africhange/theme/widgets/custom_chart.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatefulWidget {
  const CustomChart({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  bool days30 = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(
            onTap: () {
              setState(() {
                days30 = true;
              });
            },
            child: Column(
              children: [
                CFont.regular(
                    text: 'Past 30 days',
                    color:
                        days30 ? CColor.white : CColor.white.withOpacity(0.5)),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: days30 ? CColor.lightBlue : Colors.transparent),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                days30 = false;
              });
            },
            child: Column(
              children: [
                CFont.regular(
                    text: 'Past 90 days',
                    color:
                        days30 ? CColor.white.withOpacity(0.5) : CColor.white),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: days30 ? Colors.transparent : CColor.lightBlue),
                )
              ],
            ),
          ),
        ]),
        const SizedBox(height: 20),
        SizedBox(
            height: 300, child: days30 ? CChart.days30() : CChart.days90()),
      ],
    );
  }
}
