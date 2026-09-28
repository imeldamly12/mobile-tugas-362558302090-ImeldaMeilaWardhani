import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Exercise02Retry extends StatefulWidget {
  const Exercise02Retry({super.key});

  @override
  State<Exercise02Retry> createState() =>
      _Exercise02RetryState();
}

class _Exercise02RetryState
    extends State<Exercise02Retry> {
  int _jumlahPercobaan = 0;

  bool _sedangMemuat = false;

  String _status = 'Belum melakukan request';

  Future<void> _cobaRequest() async {
    setState(() {
      _jumlahPercobaan++;
      _sedangMemuat = true;
      _status = 'Sedang mencoba request...';
    });

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    try {
      // Endpoint sengaja dibuat salah untuk
      // mensimulasikan request yang gagal.
      final Response<dynamic> response = await dio.get(
        '/posts/tidak-ada',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'Request berhasil.\n'
            'Status code: ${response.statusCode}';
      });
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'Request gagal.\n\n'
            'Tipe error: ${error.type}\n'
            'Pesan: ${error.message}';
      });
    } finally {
      dio.close();

      if (mounted) {
        setState(() {
          _sedangMemuat = false;
        });
      }
    }
  }

  void _resetPercobaan() {
    setState(() {
      _jumlahPercobaan = 0;
      _status = 'Belum melakukan request';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 2 - Retry Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.refresh,
              size: 64,
            ),

            const SizedBox(height: 24),

            const Text(
              'Retry Counter',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Jumlah percobaan: $_jumlahPercobaan',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              _status,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            if (_sedangMemuat)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: _cobaRequest,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: _resetPercobaan,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}