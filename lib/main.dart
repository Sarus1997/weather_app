import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness:
              Brightness.dark, // ใช้โทนดาร์กโหมดเป็นหลักเพื่อให้ดูหรูหรา
        ),
        fontFamily:
            'Roboto', // สามารถเปลี่ยนเป็น 'Prompt' หรือ 'Kanit' ได้ถ้าลงฟอนต์ไว้
      ),
      home: const WeatherScreen(),
    );
  }
}
