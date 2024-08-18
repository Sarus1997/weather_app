import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherAPI {
  final String apiKey = '856d86217806c6682cb37f36bebe90bc';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(
      String city, BuildContext context) async {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode == 'th' ? 'th' : 'en';

    final url = '$baseUrl?q=$city&appid=$apiKey&lang=$lang&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
