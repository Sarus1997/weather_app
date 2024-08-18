import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_icons/weather_icons.dart';

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
    if (weatherData == null) {
      return Center(
        child: Text(
          isEnglish ? 'No data available' : 'ไม่มีข้อมูล',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      );
    }

    // Extracting data with null safety
    final temperature = weatherData!['main']?['temp'] ?? 0.0;
    final humidity = weatherData?['main']?['humidity'] ?? 0.0;
    final windSpeed = weatherData?['wind']?['speed'] ?? 0.0;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEnglish ? 'Real-Time Data' : 'ข้อมูลเรียลไทม์',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                Icon(Icons.access_time, color: Colors.blue[700]),
              ],
            ),
            const SizedBox(height: 10),
            buildBarChart(
              label: isEnglish ? 'Temperature (°C)' : 'อุณหภูมิ (°C)',
              value: temperature,
              maxY: 50,
            ),
            const SizedBox(height: 10),
            buildBarChart(
              label: isEnglish ? 'Humidity (%)' : 'ความชื้น (%)',
              value: humidity,
              maxY: 100,
            ),
            const SizedBox(height: 10),
            buildBarChart(
              label: isEnglish ? 'Wind Speed (m/s)' : 'ความเร็วลม (m/s)',
              value: windSpeed,
              maxY: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBarChart({
    required String label,
    required double value,
    required double maxY,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: maxY,
              barTouchData: BarTouchData(enabled: false),
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      color: Colors.blue[700],
                      width: 20,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
