import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/pages/weather_screen.dart'; // เพื่อเรียกใช้ GlassCard

class BuildBarGraph extends StatelessWidget {
  final bool isEnglish;
  final Map<String, dynamic>? weatherData;

  const BuildBarGraph({
    super.key,
    required this.isEnglish,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    if (weatherData == null) return const SizedBox.shrink();

    // ดักจับ Type และ NaN ให้ปลอดภัย
    double safeGet(dynamic value) {
      if (value == null) return 0.0;
      double v = (value as num).toDouble();
      return v.isNaN ? 0.0 : v;
    }

    final temp = safeGet(weatherData!['main']?['temp']);
    final humid = safeGet(weatherData!['main']?['humidity']);
    final wind = safeGet(weatherData!['wind']?['speed']);

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Weather Comparison' : 'เปรียบเทียบข้อมูลสภาพอากาศ',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 250, // เพิ่มความสูงให้ดูอลังการ
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100, // ตั้ง Max ไว้ที่ 100 เพื่อให้ครอบคลุม % ความชื้น
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.blueGrey.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String label = '';
                        if (group.x == 0)
                          label = isEnglish ? 'Temp' : 'อุณหภูมิ';
                        if (group.x == 1)
                          label = isEnglish ? 'Humid' : 'ความชื้น';
                        if (group.x == 2) label = isEnglish ? 'Wind' : 'แรงลม';
                        return BarTooltipItem(
                          '$label\n${rod.toY.toStringAsFixed(1)}',
                          const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold);
                          switch (value.toInt()) {
                            case 0:
                              return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(isEnglish ? 'Temp' : 'อุณหภูมิ',
                                      style: style));
                            case 1:
                              return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(isEnglish ? 'Humid' : 'ความชื้น',
                                      style: style));
                            case 2:
                              return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(isEnglish ? 'Wind' : 'ลม',
                                      style: style));
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 10)),
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.white12, strokeWidth: 1)),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeGroupData(0, temp, Colors.orangeAccent),
                    _makeGroupData(1, humid, Colors.lightBlueAccent),
                    _makeGroupData(2, wind, Colors.tealAccent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 25,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}
