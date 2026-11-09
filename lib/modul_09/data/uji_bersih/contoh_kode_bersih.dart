import 'package:flutter/material.dart';

class DaftarProdukScreen extends StatefulWidget {
  const DaftarProdukScreen({super.key});

  @override
  State<DaftarProdukScreen> createState() => _DaftarProdukScreenState();
}

class _DaftarProdukScreenState extends State<DaftarProdukScreen> {
  final TextEditingController _pencarian = TextEditingController();
  final ScrollController _gulir = ScrollController();
  
  // AI-05 sudah dihapus (API Key tidak boleh ada di kode klien)
  
  String? _pilihan;
  String? _galat;

  // AI-02: Tambahkan dispose
  @override
  void dispose() {
    _pencarian.dispose();
    _gulir.dispose();
    super.dispose();
  }

  Future<void> _ambilData() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // AI-03: Cek mounted setelah await
    if (!mounted) return;
    
    setState(() {
      _pilihan = 'Produk Baru';
    });
  }

  void _prosesData() {
    try {
      throw Exception('Gagal');
    } catch (e) {
      // AI-07: Isi catch kosong dengan debugPrint
      debugPrint('Terjadi kesalahan: $e');
    }
  }

  // AI-01 & AI-06: Ganti parameter, hapus '!', ganti print jadi debugPrint
  void _pilihProduk(String nama) {
    debugPrint('Produk dipilih: $nama');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AI-04: withOpacity diganti withValues
        backgroundColor: Colors.blue.withValues(alpha: 0.9),
      ),
      body: Column(
        children: [
          if (_galat != null) Text(_galat!),
        ],
      ),
    );
  }
}