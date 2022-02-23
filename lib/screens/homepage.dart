import 'package:africhange/constants/currency_data.dart';
import 'package:africhange/constants/custom_colors.dart';
import 'package:africhange/constants/custom_fonts.dart';
import 'package:africhange/models/forex.dart';
import 'package:africhange/theme/widgets/chart_widget.dart';
import 'package:africhange/theme/widgets/custom_chart.dart';
import 'package:africhange/theme/widgets/custom_dialog.dart';
import 'package:africhange/theme/widgets/custom_forms.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _inputController = TextEditingController(text: '1');
  TextEditingController _outputController = TextEditingController();

  List<int> _currency = List.generate(CCurrency.data.length, (index) => index);
  int _indexCurrency = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.notes_rounded, color: CColor.lightBlue),
                  CFont.regular(text: 'Sign in', color: CColor.lightBlue)
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CFont.big(
                      text: 'Currency\nCalculator', color: CColor.blueDark),
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: const BoxDecoration(
                      color: CColor.lightBlue,
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            CForms.text(controller: _inputController, label: 'EUR'),
            CForms.text(
                controller: _outputController,
                label: CCurrency.data[_indexCurrency][0],
                enabled: false),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: CColor.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: CColor.shadow,
                        border: Border.all(width: 3, color: CColor.lightGrey)),
                    child: GestureDetector(
                      onTap: () {
                        CDialog.error(context);
                      },
                      child: AspectRatio(
                        aspectRatio: 3,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/flags/fi.png'),
                              CFont.regular(text: 'EUR'),
                              const Icon(Icons.arrow_drop_down),
                              const SizedBox(width: 2),
                            ]),
                      ),
                    ),
                  ),
                  const Icon(Icons.trending_flat),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: CColor.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: CColor.shadow,
                        border: Border.all(width: 3, color: CColor.lightGrey)),
                    height: 50,
                    child: AspectRatio(
                      aspectRatio: 3,
                      child: DropdownButton<int>(
                          value: _indexCurrency,
                          underline: Container(),
                          items: _currency
                              .map((int curr) => DropdownMenuItem<int>(
                                  value: curr,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                          'assets/flags/${CCurrency.data[curr][2]}.png'),
                                      CFont.regular(
                                          text: '   ${CCurrency.data[curr][0]}',
                                          color: CColor.grey),
                                    ],
                                  )))
                              .toList(),
                          onChanged: (int? day) {
                            setState(() {
                              _indexCurrency = day!;
                            });
                          }),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await _convert();
              },
              child: Container(
                height: 60,
                width: double.maxFinite,
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: CColor.lightBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CFont.regular(text: 'Convert', color: CColor.white),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CFont.small(
                  text: 'Mid-market exchange rate at ${_time()} UTC',
                  color: CColor.blueDark,
                  underline: TextDecoration.underline),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: const BoxDecoration(
                  gradient: CColor.gradient,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  CustomChart(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CFont.small(
                        text: 'Get rate alert straight to your email inbox',
                        color: CColor.white,
                        underline: TextDecoration.underline),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _convert() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    if (double.tryParse(_inputController.text) == null) {
      return;
    }

    double _input = double.parse(_inputController.text);

    // String result =
    double result =
        await Forex.exchange('YEN', CCurrency.data[_indexCurrency][0]);

    setState(() {
      _outputController.text = (_input * result).toString();
    });

    Navigator.pop(context);
  }

  String _time() {
    DateTime _now = DateTime.now();
    return '${_now.hour}:${_now.minute}';
  }
}
