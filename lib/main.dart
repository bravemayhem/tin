import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TinApp());
}

class TinApp extends StatelessWidget {
  const TinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tampon In?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF5F7),
      ),
      home: const HomeScreen(),
    );
  }
}
