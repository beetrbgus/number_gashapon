import 'package:flutter/material.dart';
import 'package:number_gashapon/gasha/presentation/gasha_setting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
      ),
      home: const GaShaSettingScreen(),
    );
  }
}
