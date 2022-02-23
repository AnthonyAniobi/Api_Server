import 'dart:convert';

import 'package:http/http.dart' as http;

class Forex {
  static const String url = 'http://data.fixer.io/api';
  static const String api = 'dd6d1b28cf27359d0fdbdce5f9121432';

  // static Map getCurrency()
  static Future<double> exchange(String from, String to) async {
    //base currency is restricted for the free plan so the default base is used
    http.Response response = await http
        .get(Uri.parse('$url/latest?access_key=$api&symbols=$to&format=1'));
    if (response.statusCode == 200) {
      Map _rate = jsonDecode(response.body);
      return _rate['rates'][to];
    } else {
      return 0;
    }
  }

  static Future history30(String base, String to) async {
    String _90Days = _dateFrom(30);
    String _today = _dateFrom(0);
    //base currency is restricted for the free plan so the default base is used
    http.Response response = await http.get(Uri.parse(
        '$url/timeseries?access_key=$api& start_date=$_90Days&end_date= $_today&symbols=$to&format=1'));
    if (response.statusCode == 200) {
      Map _rate = jsonDecode(response.body);
      return _rate['rates'][to];
    } else {
      return 'failed';
    }
  }

  static Future history90(String base, String to) async {
    String _90Days = _dateFrom(90);
    String _today = _dateFrom(0);
    //base currency is restricted for the free plan so the default base is used
    http.Response response = await http.get(Uri.parse(
        '$url/timeseries?access_key=$api& start_date=$_90Days&end_date= $_today&symbols=$to&format=1'));
    if (response.statusCode == 200) {
      Map _rate = jsonDecode(response.body);
      print(response.body);
      return _rate['rates']['$to'];
    } else {
      return 'failed';
    }
  }

  static String _dateFrom(int day) {
    // subtract day number of days from the result
    DateTime result = DateTime.now().subtract(Duration(days: day));
    return '${result.year}-${result.month}-${result.day}';
  }
}
