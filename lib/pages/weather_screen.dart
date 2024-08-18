import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/components/line_graph.dart';
import 'package:weather_app/components/bar_graph.dart';
import 'package:weather_app/api/weather_api.dart';
import 'package:weather_app/components/map.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherAPI _weatherAPI = WeatherAPI();
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  bool _isEnglish = true;

  void _fetchWeather() async {
    String city = _controller.text.trim();
    if (city.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final data = await _weatherAPI.fetchWeather(city, context);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() => _isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weather data: $e')),
      );
    }
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEnglish ? 'Weather App' : 'แอพพยากรณ์อากาศ'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              _isEnglish ? 'assets/img/english.png' : 'assets/img/thai.png',
              width: 24,
              height: 24,
            ),
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildLargeScreenLayout();
          } else {
            return _buildSmallScreenLayout();
          }
        },
      ),
    );
  }

  Widget _buildSmallScreenLayout() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[700]!, Colors.blue[300]!],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchCard(),
              const SizedBox(height: 20),
              _buildFetchButton(),
              const SizedBox(height: 40),
              if (_weatherData != null) ..._buildWeatherInfoList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeScreenLayout() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[700]!, Colors.blue[300]!],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildSearchCard(),
                  const SizedBox(height: 10),
                  _buildFetchButton(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // const MapScreen(
                          //   cityName: '',
                          // ),
                          const SizedBox(height: 10),
                          BuildLineGraph(
                            isEnglish: _isEnglish,
                            weatherData: _weatherData,
                          ),
                          const SizedBox(height: 10),
                          BuildBarGraph(
                            isEnglish: _isEnglish,
                            weatherData: _weatherData,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: _weatherData != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ..._buildWeatherInfoList(),
                        ],
                      ),
                    )
                  : const Center(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: _isEnglish ? 'Enter city name' : 'ใส่ชื่อเมือง',
                  border: InputBorder.none,
                  icon: Icon(Icons.location_city, color: Colors.blue[700]),
                ),
                style: const TextStyle(fontFamily: 'YourThaiFont'),
                onSubmitted: (String value) {
                  _fetchWeather();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.clear, color: Colors.blue[700]),
              onPressed: () {
                setState(() {
                  _controller.clear();
                  _weatherData = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFetchButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _fetchWeather,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue[700],
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              _isEnglish ? 'Get Weather' : 'รับข้อมูลอากาศ',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
    );
  }

  List<Widget> _buildWeatherInfoList() {
    return [
      _buildWeatherInfo(_isEnglish ? 'City' : 'เมือง', _weatherData!['name'],
          Icons.location_on),
      _buildWeatherInfo(_isEnglish ? 'Temperature' : 'อุณหภูมิ',
          '${_weatherData!['main']['temp']}°C', Icons.thermostat),
      _buildWeatherInfo(_isEnglish ? 'Weather' : 'สภาพอากาศ',
          _weatherData!['weather'][0]['description'], Icons.cloud),
      _buildWeatherInfo(_isEnglish ? 'Humidity' : 'ความชื้น',
          '${_weatherData!['main']['humidity']}%', Icons.opacity),
      _buildWeatherInfo(_isEnglish ? 'Pressure' : 'ความดัน',
          '${_weatherData!['main']['pressure']} hPa', Icons.compress),
      _buildWeatherInfo(_isEnglish ? 'Wind Speed' : 'ความเร็วลม',
          '${_weatherData!['wind']['speed']} m/s', Icons.air),
      _buildWeatherInfo(_isEnglish ? 'Wind Direction' : 'ทิศทางลม',
          '${_weatherData!['wind']['deg']}°', Icons.navigation),
      _buildWeatherInfo(_isEnglish ? 'Visibility' : 'ความชัดเจน',
          '${_weatherData!['visibility'] / 1000} km', Icons.visibility),
      _buildWeatherInfo(_isEnglish ? 'Sunrise' : 'พระอาทิตย์ขึ้น',
          _formatTime(_weatherData!['sys']['sunrise']), Icons.wb_sunny),
      _buildWeatherInfo(_isEnglish ? 'Sunset' : 'พระอาทิตย์ตก',
          _formatTime(_weatherData!['sys']['sunset']), Icons.nights_stay),
    ];
  }

  Widget _buildWeatherInfo(String label, String value, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue[700], size: 30),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                const SizedBox(height: 5),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
