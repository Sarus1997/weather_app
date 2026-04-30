import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherAPI {
  final String apiKey = '856d86217806c6682cb37f36bebe90bc';
  final String base = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(
      String city, BuildContext context) async {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode == 'th' ? 'th' : 'en';

    final url = '$base?q=$city&appid=$apiKey&units=metric&lang=$lang';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Error fetching weather');
    }
  }
}
