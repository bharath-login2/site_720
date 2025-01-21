import 'dart:developer';
import 'package:http/http.dart' as http;

import '../models/dashboard/dashboard_model.dart';

class HttpServices {
  static var dev = 'https://dev.login2.in/constructEase/test_dev/v1/api/';
  static var main = 'https://dev.login2.in/constructEase/test_dev/v1/api/';
  static var baseUrl = dev;


  static Future login(mobile, password) async {
    try {
      http.Response response = await http.post(Uri.parse("${baseUrl}login"),
          body: ({'phone_number': mobile, 'password': password}));
      if (response.statusCode == 200) {
        // return loginmodelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future dashboard(fromDate, toDate) async {
    try {
      http.Response response = await http.post(Uri.parse("${baseUrl}get_dashboard"),
          body: ({'token': "", 'from_date': fromDate, 'to_date': toDate}));
      if (response.statusCode == 200) {
        return dashboardModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
