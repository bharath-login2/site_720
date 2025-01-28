import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:site_720/data/models/project_list/project_list_model.dart';

import '../models/clientlist/client_list_model.dart';
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
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_dashboard"),
          body: ({'token': "", 'from_date': fromDate, 'to_date': toDate}));
      if (response.statusCode == 200) {
        return dashboardModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }


  static Future getProjectList(status, searchKey) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_project_list"),
          body: ({
            'token': "",
            'status': status == "null" ? "" : status,
            'searchkey': searchKey
          }));
      if (response.statusCode == 200) {
        return projectListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }


  static Future getClientList() async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_client_list"));
      if (response.statusCode == 200) {
        return clientListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
