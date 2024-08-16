import 'dart:convert';

import 'package:bai_system/api/model/weather/weather.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class OpenWeatherApi {
  //logger
  static var log = Logger();

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  //Get API key from https://home.openweathermap.org/api_keys
  static const String apiKey = '9fca8cf85b3001851fb8d0ced7eb9070';

  static Future<WeatherData> fetchWeather(double lat, double lon) async {
    try {
      final url = Uri.parse(
          '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        log.i('Weather data loaded successfully');
        return WeatherData.fromJson(json.decode(response.body));
      } else {
        log.e('Failed to load weather data: ${response.statusCode}');
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      log.e('Error during get weather: $e');
      rethrow;
    }
  }

  static Future<String> fetchAirQuality(double lat, double lon) async {
    final url =
        Uri.parse('$baseUrl/air_pollution?lat=$lat&lon=$lon&appid=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      String aqi =
          json.decode(response.body)['list'][0]['main']['aqi'].toString();

      log.i('Air quality data loaded successfully: $aqi');
      return AirQuality.aqi[int.parse(aqi)]?.toString() ?? 'Unknown';
    } else {
      throw Exception('Failed to load air quality data');
    }
  }
}

class AirQuality {
  static Map<int, String> aqi = {
    1: 'Good',
    2: 'Fair',
    3: 'Moderate',
    4: 'Poor',
    5: 'Very Poor',
  };
}
