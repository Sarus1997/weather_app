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
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.blue[800]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEnglish ? 'Weather Bar Graph' : 'กราฟแท่งสภาพอากาศ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildBarChart(
                label: isEnglish ? 'Temperature (°C)' : 'อุณหภูมิ (°C)',
                value: temperature,
                maxY: 50,
              ),
              const SizedBox(height: 20),
              buildBarChart(
                label: isEnglish ? 'Humidity (%)' : 'ความชื้น (%)',
                value: humidity,
                maxY: 100,
              ),
              const SizedBox(height: 20),
              buildBarChart(
                label: isEnglish ? 'Wind Speed (m/s)' : 'ความเร็วลม (m/s)',
                value: windSpeed,
                maxY: 20,
              ),
            ],
          ),
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Colors.white30,
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      color: Colors.orangeAccent,
                      width: 20,
                      borderRadius: BorderRadius.circular(5),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        color: Colors.white24,
                        toY: maxY,
                      ),
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
