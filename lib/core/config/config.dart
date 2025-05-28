
import 'package:site_720/core/utilities/shared_preferences.dart';

class Config {
  static getUrl() async {
    String? url = await getSharedPreference("url");
    String baseUrl;
  // String? api = '/v1/api/';
  String? api = 'https://s1.site720.com/index.php/v1/api/';
    //baseUrl = url.toString() + api;
        baseUrl = api;

      return baseUrl;
  }
}
