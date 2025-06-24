import 'package:flutter/material.dart';
import 'package:p5/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Film',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Tambahkan beberapa styling global
        scaffoldBackgroundColor: Colors.grey[100], // Warna latar belakang aplikasi
        appBarTheme: const AppBarTheme(
          elevation: 0, // Hilangkan bayangan default AppBar
        ),
        cardTheme: CardTheme(
          elevation: 5, // Bayangan default untuk Card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sudut membulat default untuk Card
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.amberAccent), // Warna aksen
      ),
      home: const HomePage(),
    );
  }
}