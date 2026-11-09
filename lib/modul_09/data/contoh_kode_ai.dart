import 'package:flutter/material.dart';

class DaftarProdukScreen extends StatefulWidget {
  const DaftarProdukScreen({super.key});

  @override
  State<DaftarProdukScreen> createState() => _DaftarProdukScreenState();
}

class _DaftarProdukScreenState extends State<DaftarProdukScreen> {
  // AI-02: Controller tanpa dispose()
  final TextEditingController _pencarian = TextEditingController();
  final ScrollController _gulir = ScrollController();

  // AI-05: Kredensial keras (hardcoded)
  static const String apiKey = 'sk-live-1234567890abcdef';
  
  String? _pilihan;
  String? _galat;

  Future<void> _ambilData() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // AI-03: setState setelah await tanpa cek mounted
    setState(() {
      _pilihan = 'Produk Baru';
    });
  }

  void _prosesData() {
    try {
      // Simulasi proses
      throw Exception('Gagal');
    } catch (e) {
      // AI-07: catch kosong menelan error
    }
  }

  void _pilihProduk() {
    // AI-01: Null-assertion (!) tanpa pemeriksaan
    final String nama = _pilihan!;
    // AI-06: print() alih-alih debugPrint()
    print('Produk dipilih: $nama');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AI-04: API deprecated (withOpacity)
        backgroundColor: Colors.blue.withOpacity(0.9),
      ),
      body: Column(
        children: [
          // Baris aman (tidak ditandai AI-01 karena ada pengecekan != null)
          if (_galat != null) Text(_galat!),
        ],
      ),
    );
  }
}