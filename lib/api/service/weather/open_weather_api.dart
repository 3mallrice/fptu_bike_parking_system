import 'dart:convert';

import 'package:bai_system/api/model/weather/weather.dart';
import 'package:bai_system/component/custom_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class OpenWeatherApi {
  static var log = Logger();

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  //Get API key from https://home.openweathermap.org/api_keys
  static const String apiKey = '9fca8cf85b3001851fb8d0ced7eb9070';

  static final cacheManager = CustomCacheManager();

  static Future<WeatherData> fetchWeather(double lat, double lon) async {
    try {
      final url =
          '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

      // Check data trong cache
      final fileInfo = await cacheManager.getFileFromCache(url);
      if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
        // Nếu trong cache có data và còn hsd
        final file = fileInfo.file;
        final jsonString = await file.readAsString();
        log.i('Loaded weather data from cache');
        return WeatherData.fromJson(json.decode(jsonString));
      } else {
        // Trong cache không có data / đã hết hsd (30p)
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          log.i('Weather data loaded from API');
          // Lưu vào cache
          await cacheManager.putFile(
            url,
            response.bodyBytes,
            fileExtension: 'json',
            maxAge: const Duration(minutes: 30),
          );
          return WeatherData.fromJson(json.decode(response.body));
        } else {
          log.e('Failed to load weather data: ${response.statusCode}');
          throw Exception('Failed to load weather data');
        }
      }
    } catch (e) {
      log.e('Error during get weather: $e');
      rethrow;
    }
  }

  static Future<String> fetchAirQuality(double lat, double lon) async {
    try {
      final url = '$baseUrl/air_pollution?lat=$lat&lon=$lon&appid=$apiKey';

      // Check data trong cache
      final fileInfo = await cacheManager.getFileFromCache(url);
      if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
        // Nếu trong cache có data và còn hsd
        final file = fileInfo.file;
        final jsonString = await file.readAsString();
        String aqi =
            json.decode(jsonString)['list'][0]['main']['aqi'].toString();
        log.i('Loaded air quality data from cache: $aqi');
        return AirQuality.aqi[int.parse(aqi)] ?? 'Unknown';
      } else {
        // Trong cache không có data / đã hết hsd (30p)
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          log.i('Air quality data loaded from API');
          // Lưu vào cache
          await cacheManager.putFile(
            url,
            response.bodyBytes,
            fileExtension: 'json',
            maxAge: const Duration(minutes: 30),
          );
          String aqi =
              json.decode(response.body)['list'][0]['main']['aqi'].toString();
          return AirQuality.aqi[int.parse(aqi)] ?? '-';
        } else {
          log.e('Failed to load air quality data: ${response.statusCode}');
          throw Exception('Failed to load air quality data');
        }
      }
    } catch (e) {
      log.e('Error during get air quality: $e');
      rethrow;
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
