import 'package:flutter/material.dart';

import 'modul_04/screens/announcement_list_screen.dart';
import 'modul_04/services/announcement_api.dart';

void main() {
  runApp(const KantinApp());
}

class KantinApp extends StatelessWidget {
  const KantinApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bool kModeSimulasi = bool.fromEnvironment('SIMULASI');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portal Pengumuman TRPL',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: AnnouncementListScreen(
        api: AnnouncementApi(
          modeSimulasi: kModeSimulasi,
        ),
      ),
    );
  }
}