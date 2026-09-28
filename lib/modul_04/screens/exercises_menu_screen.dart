import 'package:flutter/material.dart';

import '../exercises/exercises_01_timeout.dart';
import '../exercises/exercises_02_retry.dart';
import '../exercises/exercises_03_search.dart';

class ExerciseMenuScreen extends StatelessWidget {
  const ExerciseMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Fase B'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          // ==========================================================
          // LATIHAN 1
          // ==========================================================

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.timer_outlined,
              ),
              title: const Text(
                'Latihan 1 - Timeout',
              ),
              subtitle: const Text(
                'Menguji batas waktu request menggunakan Dio',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const Exercise01Timeout(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ==========================================================
          // LATIHAN 2
          // ==========================================================

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.refresh,
              ),
              title: const Text(
                'Latihan 2 - Retry Counter',
              ),
              subtitle: const Text(
                'Menghitung jumlah percobaan request',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const Exercise02Retry(),
                  ),
                );

                
              },
            ),
          ),

          const SizedBox(height: 12),

Card(
  child: ListTile(
    leading: const Icon(
      Icons.search,
    ),
    title: const Text(
      'Latihan 3 - Title Search',
    ),
    subtitle: const Text(
      'Mencari pengumuman berdasarkan judul',
    ),
    trailing: const Icon(
      Icons.chevron_right,
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) =>
              const Exercise03Search(),
        ),
      );
    },
  ),
),
        ],
      ),
    );
  }
  
}

