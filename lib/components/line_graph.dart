import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/pages/weather_screen.dart'; // เพื่อเรียกใช้ GlassCard

class BuildLineGraph extends StatelessWidget {
  final bool isEnglish;
  final Map<String, dynamic>? weatherData;

  const BuildLineGraph({
    super.key,
    required this.isEnglish,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    if (weatherData == null) return const SizedBox.shrink();

    final temperature =
        (weatherData!['main']?['temp'] as num?)?.toDouble() ?? 0.0;
    final humidity =
        (weatherData?['main']?['humidity'] as num?)?.toDouble() ?? 0.0;
    final windSpeed =
        (weatherData?['wind']?['speed'] as num?)?.toDouble() ?? 0.0;
    final visibility =
        ((weatherData?['visibility'] as num?)?.toDouble() ?? 0.0) / 1000;
    ;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish
                  ? 'Weather Overview (Line)'
                  : 'ภาพรวมสภาพอากาศ (กราฟเส้น)',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.white12, strokeWidth: 1),
                    getDrawingVerticalLine: (value) =>
                        FlLine(color: Colors.white12, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const style =
                              TextStyle(color: Colors.white70, fontSize: 12);
                          switch (value.toInt()) {
                            case 0:
                              return Text(isEnglish ? 'Temp' : 'อุณหภูมิ',
                                  style: style);
                            case 1:
                              return Text(isEnglish ? 'Humid' : 'ความชื้น',
                                  style: style);
                            case 2:
                              return Text(isEnglish ? 'Wind' : 'ลม',
                                  style: style);
                            case 3:
                              return Text(isEnglish ? 'Vis' : 'ทัศนวิสัย',
                                  style: style);
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, temperature),
                        FlSpot(1, humidity),
                        FlSpot(2, windSpeed),
                        FlSpot(3, visibility)
                      ],
                      isCurved: true,
                      color: Colors.cyanAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.cyanAccent.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
