import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/components/line_graph.dart';
import 'package:weather_app/components/bar_graph.dart';
import 'package:weather_app/api/weather_api.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
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
    FocusScope.of(context).unfocus(); // ซ่อนคีย์บอร์ดหลังจากกดค้นหา

    try {
      final data = await _weatherAPI.fetchWeather(city, context);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) print(e);
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching weather data: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _toggleLanguage() {
    setState(() => _isEnglish = !_isEnglish);
  }

  @override
  Widget build(BuildContext context) {
    // กำหนดพื้นหลังแบบ Gradient ที่ดูมีมิติ
    final gradientColors = _weatherData != null
        ? [
            const Color(0xFF1A2980),
            const Color(0xFF26D0CE)
          ] // โทนสีเมื่อมีข้อมูล
        : [
            const Color(0xFF0F2027),
            const Color(0xFF203A43),
            const Color(0xFF2C5364)
          ]; // โทนสีหน้าแรก

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isEnglish ? 'Weather App' : 'แอปพยากรณ์อากาศ',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                _isEnglish ? 'TH' : 'EN',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            // หากมีรูปธงชาติใช้ Image.asset('assets/img/english.png') แบบเดิมได้
            onPressed: _toggleLanguage,
            tooltip: _isEnglish ? 'Switch to Thai' : 'เปลี่ยนเป็นภาษาอังกฤษ',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _weatherData == null
                ? _buildWelcomeScreen()
                : _buildDashboardScreen(context),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black12,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isEnglish
                  ? 'Developed by ⚒️ Saharat Suwannapapond'
                  : 'พัฒนาโดย ⚒️ สหรัฐ สุวรรณภาพร',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            Text(
              _isEnglish
                  ? '© $currentYear All rights reserved.'
                  : '© $currentYear สงวนลิขสิทธิ์',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // หน้าต้อนรับ (Logo & Search ใหญ่ตรงกลาง)
  // ---------------------------------------------------------------------------
  Widget _buildWelcomeScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // โลโก้ (สามารถเปลี่ยนเป็น Image.asset ได้)
            const Icon(Icons.cloud_circle, size: 120, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              _isEnglish ? 'Discover the Weather' : 'ค้นหาสภาพอากาศ',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              _isEnglish
                  ? 'Enter a city name to get started'
                  : 'พิมพ์ชื่อเมืองเพื่อเริ่มต้นการค้นหา',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            _buildSearchBox(isLarge: true),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // หน้าแสดงข้อมูล (Dashboard แบบ Responsive)
  // ---------------------------------------------------------------------------
  Widget _buildDashboardScreen(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _buildSearchBox(isLarge: false),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const BouncingScrollPhysics(),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildMainInfoAndGraphs()),
                      const SizedBox(width: 20),
                      Expanded(flex: 2, child: _buildWeatherGrid()),
                    ],
                  )
                : Column(
                    children: [
                      _buildMainHeroCard(),
                      const SizedBox(height: 20),
                      _buildWeatherGrid(),
                      const SizedBox(height: 20),
                      BuildLineGraph(
                          isEnglish: _isEnglish, weatherData: _weatherData),
                      const SizedBox(height: 10),
                      BuildBarGraph(
                          isEnglish: _isEnglish, weatherData: _weatherData),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfoAndGraphs() {
    return Column(
      children: [
        _buildMainHeroCard(),
        const SizedBox(height: 20),
        BuildLineGraph(isEnglish: _isEnglish, weatherData: _weatherData),
        const SizedBox(height: 10),
        BuildBarGraph(isEnglish: _isEnglish, weatherData: _weatherData),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ส่วนประกอบ UI (Components)
  // ---------------------------------------------------------------------------

  // กล่องค้นหาแบบ Glassmorphism
  Widget _buildSearchBox({required bool isLarge}) {
    return Container(
      constraints: BoxConstraints(maxWidth: isLarge ? 500 : double.infinity),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: _isEnglish ? 'Search city...' : 'ค้นหาเมือง...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _fetchWeather(),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)),
            )
          else if (_weatherData != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white70),
              onPressed: () {
                setState(() {
                  _controller.clear();
                  _weatherData = null;
                });
              },
            ),
        ],
      ),
    );
  }

  // การ์ดหลักแสดงอุณหภูมิ (Hero Card)
  Widget _buildMainHeroCard() {
    final temp = _weatherData!['main']['temp'].round();
    final city = _weatherData!['name'];
    final desc = _weatherData!['weather'][0]['description'];

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(city,
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 10),
            Text('$temp°',
                style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w200,
                    color: Colors.white)),
            Text(desc.toString().toUpperCase(),
                style: const TextStyle(
                    fontSize: 20, letterSpacing: 2, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // จัดการ์ดข้อมูลย่อยให้อยู่ใน Grid สวยงาม
  Widget _buildWeatherGrid() {
    final infoList = [
      {
        'label': _isEnglish ? 'Humidity' : 'ความชื้น',
        'value': '${_weatherData!['main']['humidity']}%',
        'icon': Icons.water_drop
      },
      {
        'label': _isEnglish ? 'Wind' : 'ลม',
        'value': '${_weatherData!['wind']['speed']} m/s',
        'icon': Icons.air
      },
      {
        'label': _isEnglish ? 'Pressure' : 'ความดัน',
        'value': '${_weatherData!['main']['pressure']} hPa',
        'icon': Icons.compress
      },
      {
        'label': _isEnglish ? 'Visibility' : 'ทัศนวิสัย',
        'value': '${_weatherData!['visibility'] / 1000} km',
        'icon': Icons.visibility
      },
      {
        'label': _isEnglish ? 'Sunrise' : 'อาทิตย์ขึ้น',
        'value': _formatTime(_weatherData!['sys']['sunrise']),
        'icon': Icons.wb_twilight
      },
      {
        'label': _isEnglish ? 'Sunset' : 'อาทิตย์ตก',
        'value': _formatTime(_weatherData!['sys']['sunset']),
        'icon': Icons.nights_stay
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // ปรับแต่งให้พอดีกับหน้าจอ
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: infoList.length,
      itemBuilder: (context, index) {
        final item = infoList[index];
        return GlassCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item['icon'] as IconData, color: Colors.white70, size: 30),
              const SizedBox(height: 8),
              Text(item['label'] as String,
                  style: const TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 4),
              Text(item['value'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Widget เสริมสำหรับทำพื้นหลังใส (Glassmorphism)
class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
