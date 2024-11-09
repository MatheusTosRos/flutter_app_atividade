import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() {
  runApp(const HistoriasBRApp());
}

class HistoriasBRApp extends StatelessWidget {
  const HistoriasBRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Histórias BR',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: const Color(0xFF006400), // Verde escuro
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
