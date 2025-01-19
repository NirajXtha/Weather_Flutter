import "dart:convert";

import 'package:http/http.dart' as http;
import "package:weather/utils/api.dart";

class ApiCall {
  String url = Api.baseUrl;
  // late var baseUrl = Uri.parse("http://localhost/api_test/");

  Future<dynamic> getWeatherData(String location) async {
    final baseUrl = Uri.parse("$url$location");
    try {
      var response = await http.get(baseUrl);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}