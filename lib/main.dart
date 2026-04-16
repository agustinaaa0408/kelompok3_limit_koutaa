import 'package:flutter/material.dart';
import 'package:limit_kuota/src/features/monitoring/home_page.dart';
import 'package:limit_kuota/src/features/monitoring/network_page.dart';
import 'package:limit_kuota/src/features/splash_screen.dart';

void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      debugShowCheckedModeBanner: false, 
      home: SplashScreen(),
    );
  }
}