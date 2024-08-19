import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

    final temperature = weatherData!['main']?['temp']?.toDouble() ?? 0.0;
    final humidity = weatherData?['main']?['humidity']?.toDouble() ?? 0.0;
    final windSpeed = weatherData?['wind']?['speed']?.toDouble() ?? 0.0;
    final visibility = (weatherData?['visibility']?.toDouble() ?? 0.0) / 1000;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEnglish ? 'Weather Line Graph' : 'กราฟเส้นสภาพอากาศ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0) {
                            return const SizedBox.shrink();
                          }
                          switch (value.toInt()) {
                            case 0:
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(isEnglish ? 'Temp' : 'อุณหภูมิ'),
                              );
                            case 1:
                              return Text(isEnglish ? 'Humidity' : 'ความชื้น');
                            case 2:
                              return Text(isEnglish ? 'Wind' : 'ลม');
                            case 3:
                              return Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: Text(
                                    isEnglish ? 'Visibility' : 'ทัศนวิสัย'),
                              );
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, temperature),
                        FlSpot(1, temperature),
                        FlSpot(2, temperature),
                        FlSpot(3, temperature)
                      ],
                      isCurved: true,
                      color: Colors.redAccent,
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.redAccent.withOpacity(0.3),
                      ),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, humidity),
                        FlSpot(1, humidity),
                        FlSpot(2, humidity),
                        FlSpot(3, humidity)
                      ],
                      isCurved: true,
                      color: Colors.greenAccent,
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.greenAccent.withOpacity(0.3),
                      ),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, windSpeed),
                        FlSpot(1, windSpeed),
                        FlSpot(2, windSpeed),
                        FlSpot(3, windSpeed)
                      ],
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blueAccent.withOpacity(0.3),
                      ),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, visibility),
                        FlSpot(1, visibility),
                        FlSpot(2, visibility),
                        FlSpot(3, visibility)
                      ],
                      isCurved: true,
                      color: Colors.orangeAccent,
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orangeAccent.withOpacity(0.3),
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
