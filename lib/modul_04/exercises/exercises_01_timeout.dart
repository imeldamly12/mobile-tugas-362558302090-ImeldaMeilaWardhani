import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Exercise01Timeout extends StatefulWidget {
  const Exercise01Timeout({super.key});

  @override
  State<Exercise01Timeout> createState() =>
      _Exercise01TimeoutState();
}

class _Exercise01TimeoutState
    extends State<Exercise01Timeout> {
  String _status = 'Belum melakukan request';

  Future<void> _testTimeout() async {
    setState(() {
      _status = 'Sedang melakukan request...';
    });

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    try {
      final Response<dynamic> response = await dio.get(
        '/posts',
        queryParameters: <String, dynamic>{
          '_limit': 5,
        },
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
            'Request gagal.\n'
            'Tipe error: ${error.type}\n'
            'Pesan: ${error.message}';
      });
    } finally {
      dio.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 1 - Timeout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.timer_outlined,
              size: 64,
            ),

            const SizedBox(height: 24),

            Text(
              _status,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _testTimeout,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Test Request'),
            ),
          ],
        ),
      ),
    );
  }
}