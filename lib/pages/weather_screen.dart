import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/components/line_graph.dart';
import 'package:weather_app/components/bar_graph.dart';
import 'package:weather_app/api/weather_api.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

final int currentYear = DateTime.now().year;

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
        toolbarHeight: 40.0,
        title: Text(
          _isEnglish ? 'Weather App' : 'แอพพยากรณ์อากาศ',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        shadowColor: Colors.blueAccent.withOpacity(0.5),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              _isEnglish ? 'assets/img/english.png' : 'assets/img/thai.png',
              width: 28,
              height: 28,
            ),
            onPressed: _toggleLanguage,
            tooltip: _isEnglish ? 'Switch to Thai' : 'เปลี่ยนเป็นภาษาอังกฤษ',
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
      bottomNavigationBar: BottomAppBar(
        height: 37.0,
        color: Colors.blue[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  _isEnglish
                      ? 'Developed by ⚒️ Saharat Suwannapapond'
                      : 'พัฒนาโดย ⚒️ สหรัฐ สุวรรณภาพร',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 23, 5, 104),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  _isEnglish
                      ? '© $currentYear All rights reserved.'
                      : '© $currentYear สงวนลิขสิทธิ์',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 173, 20, 87),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Place the Search Card and Fetch Button in a Row
            Row(
              children: [
                Expanded(child: _buildSearchCard()),
                const SizedBox(width: 8),
                _buildClearButton(),
              ],
            ),
            const SizedBox(height: 10),
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
      child: Container(
        color: Colors.blue[200]!.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: _isEnglish ? Alignment.centerLeft : Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSearchCard(),
                          const SizedBox(
                              width:
                                  5),
                          _buildClearButton(),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              BuildLineGraph(
                                isEnglish: _isEnglish,
                                weatherData: _weatherData,
                              ),
                              const SizedBox(height: 5),
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
                const SizedBox(width: 10),
                Expanded(
                  child: _weatherData != null
                      ? SingleChildScrollView(
                          child: Column(
                            children: _buildWeatherInfoList(),
                          ),
                        )
                      : const Center(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
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
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  color: Colors.black,
                ),
                onSubmitted: (String value) {
                  _fetchWeather();
                },
              ),
            ),
            const SizedBox(width: 8),
            _buildFetchButton(),
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
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            )
          : Text(
              _isEnglish ? 'Search' : 'ค้นหา',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
    );
  }

  Widget _buildClearButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 2,
          minimumSize: const Size(50, 40),
        ),
        onPressed: () {
          setState(() {
            _controller.clear();
            _weatherData = null;
          });
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.clear, color: Colors.white, size: 16),
          ],
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue[600], size: 24),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 18, color: Colors.grey[500])),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
