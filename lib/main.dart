import 'package:flutter/material.dart';
import 'package:p5/screens/home_page.dart'; // Sesuaikan path ini

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(), // Halaman utama yang sudah dibuat
    );
  }
}
