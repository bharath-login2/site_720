import 'package:site_720/core/utilities/shared_preferences.dart';

class Config {
  static getUrl() async {
    String? url = await getSharedPreference("url");
    String baseUrl;
    String? api = '/v1/api/';
    baseUrl = url.toString() + api;
      return baseUrl;
  }
}
