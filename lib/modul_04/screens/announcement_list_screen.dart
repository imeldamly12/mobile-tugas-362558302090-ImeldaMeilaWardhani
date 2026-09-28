import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../services/announcement_api.dart';
import '../widgets/announcement_card.dart';
import 'announcement_detail_screen.dart';
import 'exercises_menu_screen.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({
    super.key,
    this.api,
  });

  /// API dapat disuntikkan dari luar untuk widget test
  /// atau kebutuhan simulasi.
  final AnnouncementApi? api;

  @override
  State<AnnouncementListScreen> createState() =>
      _AnnouncementListScreenState();
}

class _AnnouncementListScreenState
    extends State<AnnouncementListScreen> {
  // ============================================================
  // DAFTAR KATEGORI
  // ============================================================

  static const List<String> _kategori = <String>[
    'Semua',
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Prestasi',
  ];

  // ============================================================
  // API DAN FUTURE
  // ============================================================

  late final AnnouncementApi _api =
      widget.api ?? AnnouncementApi();

  late Future<List<Announcement>> _futurePengumuman;

  // Kategori yang sedang dipilih
  String _kategoriTerpilih = 'Semua';

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Request pertama dijalankan satu kali ketika halaman dibuat.
    _futurePengumuman = _api.ambilPengumuman();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _api.tutup();
    super.dispose();
  }

  // ============================================================
  // REFRESH DATA
  // ============================================================

  Future<void> _muatUlang() async {
    final Future<List<Announcement>> futureBaru =
        _api.ambilPengumuman();

    setState(() {
      _futurePengumuman = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {
      // Error akan ditampilkan oleh FutureBuilder.
      // Catch digunakan agar RefreshIndicator tidak
      // mendapatkan unhandled exception.
    }
  }

  // ============================================================
  // PILIH KATEGORI
  // ============================================================

  void _pilihKategori(String kategori) {
    if (kategori == _kategoriTerpilih) {
      return;
    }

    setState(() {
      _kategoriTerpilih = kategori;
    });
  }

  // ============================================================
  // BUKA DETAIL
  // ============================================================

  void _bukaDetail(Announcement announcement) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AnnouncementDetailScreen(
          announcement: announcement,
        ),
      ),
    );
  }

  // ============================================================
  // BUKA MENU LATIHAN FASE B
  // ============================================================

  void _bukaLatihanFaseB() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const ExerciseMenuScreen(),
      ),
    );
  }

  // ============================================================
  // BUILD UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Pengumuman TRPL'),
        actions: <Widget>[
          // Tombol refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Data',
            onPressed: _muatUlang,
          ),

          // Tombol menuju latihan Fase B
          IconButton(
            icon: const Icon(Icons.school_outlined),
            tooltip: 'Latihan Fase B',
            onPressed: _bukaLatihanFaseB,
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          // Filter kategori
          _buildBarisFilter(),

          const Divider(height: 1),

          // Area daftar pengumuman
          Expanded(
            child: FutureBuilder<List<Announcement>>(
              future: _futurePengumuman,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Announcement>> snapshot,
              ) {
                // ========================================================
                // KEADAAN 1: LOADING
                // ========================================================

                if (snapshot.connectionState !=
                    ConnectionState.done) {
                  return _buildMemuat();
                }

                // ========================================================
                // KEADAAN 2: ERROR
                // ========================================================

                if (snapshot.hasError) {
                  return _buildGagal(snapshot.error!);
                }

                // ========================================================
                // DATA
                // ========================================================

                final List<Announcement> semua =
                    snapshot.data ?? const <Announcement>[];

                // ========================================================
                // FILTER KATEGORI
                // ========================================================

                final List<Announcement> tampil =
                    _kategoriTerpilih == 'Semua'
                        ? semua
                        : semua
                            .where(
                              (Announcement item) =>
                                  item.category.toLowerCase() ==
                                  _kategoriTerpilih.toLowerCase(),
                            )
                            .toList(growable: false);

                // ========================================================
                // KEADAAN 3: KOSONG
                // ========================================================

                if (tampil.isEmpty) {
                  return _buildKosong();
                }

                // ========================================================
                // KEADAAN 4: BERHASIL
                // ========================================================

                return _buildDaftar(tampil);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER KATEGORI
  // ============================================================

  Widget _buildBarisFilter() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _kategori.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final String kategori = _kategori[index];

          return ChoiceChip(
            label: Text(kategori),
            selected: kategori == _kategoriTerpilih,
            onSelected: (_) {
              _pilihKategori(kategori);
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // KEADAAN LOADING
  // ============================================================

  Widget _buildMemuat() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Memuat pengumuman...',
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KEADAAN ERROR
  // ============================================================

  Widget _buildGagal(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.cloud_off,
              size: 64,
            ),

            const SizedBox(height: 16),

            const Text(
              'Gagal memuat pengumuman',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // KEADAAN KOSONG
  // ============================================================

  Widget _buildKosong() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.inbox_outlined,
              size: 64,
            ),

            const SizedBox(height: 16),

            const Text(
              'Belum ada pengumuman',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _kategoriTerpilih == 'Semua'
                  ? 'Belum ada data pengumuman yang tersedia.'
                  : 'Belum ada pengumuman untuk kategori '
                      '$_kategoriTerpilih.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Muat Ulang'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // KEADAAN BERHASIL
  // ============================================================

  Widget _buildDaftar(
    List<Announcement> pengumuman,
  ) {
    return RefreshIndicator(
      onRefresh: _muatUlang,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: pengumuman.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final Announcement announcement =
              pengumuman[index];

          return AnnouncementCard(
            announcement: announcement,
            onTap: () {
              _bukaDetail(announcement);
            },
          );
        },
      ),
    );
  }
}