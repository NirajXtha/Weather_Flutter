import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // TimeOfDay time = TimeOfDay.now();
  // DateTime dateTime = DateTime.now();
  String temperatureUnit = "C";
  String windSpeedUnit = "km/h";
  String pressureUnit = "hPa";
  String visibilityUnit = "km";
  String location = "Thankot";

  String tempC = "18.3";
  String temp = "16.3";
  String tempF = "64.9";
  String condition = 'Partly Cloudy';
  String icon = 'https://cdn.weatherapi.com/weather/64x64/day/116.png';
  String windKph = "6.5";
  String windSpeed = "6.5";
  String windMph = "4.0";
  String windDirection = 'W';
  String humidity = "42";
  String presssureMb = "1019.0";
  String presssure = "1019.0";
  String pressureIn = "30.09";
  String visibilityKm = "7.0";
  String visibility = "7.0";
  String visibilityMiles = "4.0";
  String uv = "3.1";

  List forecast = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []];
  // dynamic forecastData = [{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},];

  SettingsProvider() {
    getPreData();
  }

  dynamic getPreData() async {
    final prefs = await SharedPreferences.getInstance();
    temperatureUnit = prefs.getString('temperatureUnit') ?? "C";
    windSpeedUnit = prefs.getString('windSpeedUnit') ?? "km/h";
    pressureUnit = prefs.getString('pressureUnit') ?? "hPa";
    visibilityUnit = prefs.getString('visibilityUnit') ?? "km";
    location = prefs.getString('location') ?? "Thankot";
    tempC = prefs.getString('tempC') ?? "16.3";
    tempF = prefs.getString('tempF') ?? "64.9";
    condition = prefs.getString('condition') ?? 'Partly Cloudy';
    icon = prefs.getString('icon') ??
        'https://cdn.weatherapi.com/weather/64x64/day/116.png';
    windKph = prefs.getString('windKph') ?? "6.5";
    windSpeed = prefs.getString('windSpeed') ?? "6.5";
    windMph = prefs.getString('windMph') ?? "4.0";
    windDirection = prefs.getString('windDirection') ?? 'W';
    humidity = prefs.getString('humidity') ?? "42";
    presssureMb = prefs.getString('presssureMb') ?? "1019.0";
    presssure = prefs.getString('presssure') ?? "1019.0";
    pressureIn = prefs.getString('pressureIn') ?? "30.09";
    visibilityKm = prefs.getString('visibilityKm') ?? "7.0";
    visibility = prefs.getString('visibility') ?? "7.0";
    visibilityMiles = prefs.getString('visibilityMiles') ?? "4.0";
    uv = prefs.getString('uv') ?? "3.1";

    for (int i = 0; i < 24; i++) {
      forecast[i] = prefs.getStringList('forecast$i')?? 
          ["16.3", "64.9", "Partly Cloudy", "https://cdn.weatherapi.com/weather/64x64/day/116.png"];
    }
    updateData();
    notifyListeners();
  }

  void updateTemperatureUnit(String newUnit) async {
    temperatureUnit = newUnit;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('temperatureUnit', temperatureUnit);
    notifyListeners();
  }

  void updateWindSpeedUnit(String newUnit) async {
    windSpeedUnit = newUnit;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('windSpeedUnit', windSpeedUnit);
    notifyListeners();
  }

  void updatePressureUnit(String newUnit) async {
    pressureUnit = newUnit;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pressureUnit', pressureUnit);
    notifyListeners();
  }

  void updateVisibilityUnit(String newUnit) async {
    visibilityUnit = newUnit;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('visibilityUnit', visibilityUnit);
    notifyListeners();
  }

  void updateLocation(String newLocation) async {
    location = newLocation;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('location', location);
    notifyListeners();
  }

  Future<void> updateWeatherData(var data) async {
    tempC = data['current']['temp_c'].toString();
    tempF = data['current']['temp_f'].toString();
    condition = data['current']['condition']['text'].toString();
    icon = data['current']['condition']['icon'].toString();
    windKph = data['current']['wind_kph'].toString();
    windMph = data['current']['wind_mph'].toString();
    windDirection = data['current']['wind_dir'].toString();
    humidity = data['current']['humidity'].toString();
    presssureMb = data['current']['pressure_mb'].toString();
    pressureIn = data['current']['pressure_in'].toString();
    visibilityKm = data['current']['vis_km'].toString();
    visibilityMiles = data['current']['vis_miles'].toString();
    uv = data['current']['uv'].toString();
    updateData();

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('tempC', tempC);
    prefs.setString('tempF', tempF);
    prefs.setString('condition', condition);
    prefs.setString('icon', icon);
    prefs.setString('windKph', windKph);
    prefs.setString('windMph', windMph);
    prefs.setString('windDirection', windDirection);
    prefs.setString('humidity', humidity);
    prefs.setString('presssureMb', presssureMb);
    prefs.setString('pressureIn', pressureIn);
    prefs.setString('visibilityKm', visibilityKm);
    prefs.setString('visibilityMiles', visibilityMiles);
    prefs.setString('uv', uv);

    prefs.setInt('len', data['forecast']['forecastday'][0]['hour'].length);
    try {
      int i = 0;
      while (i <= data['forecast']['forecastday'][0]['hour'].length) {
        // final DateTime dateTime = DateTime.parse(
        //     data['forecast']['forecastday'][0]['hour'][i]['time']);
        // final TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
        // var timeString = time.toString();
        var tempc =
            data['forecast']['forecastday'][0]['hour'][i]['temp_c'].toString();
        var tempf =
            data['forecast']['forecastday'][0]['hour'][i]['temp_f'].toString();
        var condition =
            data['forecast']['forecastday'][0]['hour'][i]['condition']['text'];
        var icon =
            data['forecast']['forecastday'][0]['hour'][i]['condition']['icon'];
        List<String> fd = [];
        fd = [tempc, tempf, condition, icon];
        // print(fd);

        prefs.setStringList('forecast$i', fd);

        // print(prefs.getStringList('forecast$i'));

        i++;
      }
    } catch (e) {
      print("Error: $e");
    }
    notifyListeners(); 
  }

  Future<void> updateData() async {
    if (temperatureUnit == "C") {
      temp = tempC;
    } else {
      temp = tempF;
    }
    if (windSpeedUnit == "km/h") {
      windSpeed = windKph;
    } else {
      windSpeed = windMph;
    }
    if (pressureUnit == "hPa") {
      presssure = presssureMb;
    } else {
      presssure = pressureIn;
    }
    if (visibilityUnit == "km") {
      visibility = visibilityKm;
    } else {
      visibility = visibilityMiles;
    }
  }
}// am back sorry