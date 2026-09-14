import 'package:flutter/material.dart';
import 'modul_02/Studi kasus/ruang_praktikum.dart'; // Sesuaikan jalur impor jika diperlukan

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Praktikum Poliwangi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RuangPraktikumScreen(),
    );
  }
}