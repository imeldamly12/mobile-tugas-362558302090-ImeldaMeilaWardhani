import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Exercise03Search extends StatefulWidget {
  const Exercise03Search({super.key});

  @override
  State<Exercise03Search> createState() =>
      _Exercise03SearchState();
}

class _Exercise03SearchState
    extends State<Exercise03Search> {
  final TextEditingController _searchController =
      TextEditingController();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  List<Map<String, dynamic>> _semuaData =
      <Map<String, dynamic>>[];

  List<Map<String, dynamic>> _hasilPencarian =
      <Map<String, dynamic>>[];

  bool _sedangMemuat = true;

  String _pesanError = '';

  @override
  void initState() {
    super.initState();
    _ambilData();
    _searchController.addListener(_cariJudul);
  }

  Future<void> _ambilData() async {
    setState(() {
      _sedangMemuat = true;
      _pesanError = '';
    });

    try {
      final Response<dynamic> response = await _dio.get(
        '/posts',
        queryParameters: <String, dynamic>{
          '_limit': 10,
        },
      );

      final List<dynamic> data =
          response.data as List<dynamic>;

      final List<Map<String, dynamic>> hasil =
          data
              .map(
                (dynamic item) =>
                    Map<String, dynamic>.from(
                  item as Map,
                ),
              )
              .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _semuaData = hasil;
        _hasilPencarian = hasil;
        _sedangMemuat = false;
      });
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _sedangMemuat = false;
        _pesanError =
            'Gagal mengambil data.\n'
            '${error.message}';
      });
    }
  }

  void _cariJudul() {
    final String kataKunci =
        _searchController.text.trim().toLowerCase();

    if (kataKunci.isEmpty) {
      setState(() {
        _hasilPencarian = _semuaData;
      });
      return;
    }

    final List<Map<String, dynamic>> hasil =
        _semuaData.where(
      (Map<String, dynamic> item) {
        final String judul =
            (item['title'] ?? '').toString().toLowerCase();

        return judul.contains(kataKunci);
      },
    ).toList();

    setState(() {
      _hasilPencarian = hasil;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 3 - Title Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari berdasarkan judul',
                hintText: 'Contoh: sunt',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            if (_sedangMemuat)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_pesanError.isNotEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    _pesanError,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (_hasilPencarian.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Tidak ada judul yang sesuai.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _hasilPencarian.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    final Map<String, dynamic> item =
                        _hasilPencarian[index];

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            '${item['id']}',
                          ),
                        ),
                        title: Text(
                          '${item['title']}',
                        ),
                        subtitle: Text(
                          'User ID: ${item['userId']}',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
