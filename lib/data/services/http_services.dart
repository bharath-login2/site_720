import 'dart:developer';
import 'package:http/http.dart' as http;

class HttpServices {
  static var baseUrl = '';

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
}
