import 'package:flutter/material.dart';

import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;
  final DateTime sekarang;
  final VoidCallback? onKeluar;
  final bool sedangKeluar;
  final bool tampilkanToken;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.sekarang,
    this.onKeluar,
    this.sedangKeluar = false,
    this.tampilkanToken = false,
  });

  static String samarkanToken(String token) {
    if (token.isEmpty) return '(kosong)';
    if (token.length <= 6) return _titik(token.length);
    return '${token.substring(0, 6)}${_titik(12)}';
  }

  static String _titik(int jumlah) =>
      List<String>.filled(jumlah, '\u2022').join();

  static String formatWaktu(String iso) {
    const List<String> bulan = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final DateTime? waktu = DateTime.tryParse(iso);
    if (waktu == null) return 'tidak diketahui';

    final String jam = waktu.hour.toString().padLeft(2, '0');
    final String menit = waktu.minute.toString().padLeft(2, '0');

    return '${waktu.day} ${bulan[waktu.month - 1]} ${waktu.year}, '
        '$jam:$menit';
  }

  static String formatSisa(Duration sisa) {
    if (sisa.inSeconds <= 0) return 'sudah berakhir';
    if (sisa.inMinutes < 1) return '${sisa.inSeconds} detik';
    if (sisa.inHours < 1) return '${sisa.inMinutes} menit';

    final int menit = sisa.inMinutes.remainder(60);

    return menit == 0
        ? '${sisa.inHours} jam'
        : '${sisa.inHours} jam $menit menit';
  }

  @override
  Widget build(BuildContext context) {
    final Duration sisa = sesi.sisaWaktu(sekarang);
    final bool kedaluwarsa = sesi.sudahKedaluwarsa(sekarang);

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.person_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        sesi.nama,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(sesi.email),
                      Text(SesiPengguna.labelPeran(sesi.peran)),
                    ],
                  ),
                ),
                Icon(
                  kedaluwarsa
                      ? Icons.warning_amber_rounded
                      : Icons.verified_user_rounded,
                  color: kedaluwarsa ? Colors.red : Colors.green,
                ),
              ],
            ),
            const Divider(height: 28),
            _barisInfo(
              context,
              'Status sesi',
              kedaluwarsa ? 'Kedaluwarsa' : 'Aktif',
            ),
            const SizedBox(height: 10),
            _barisInfo(
              context,
              'Waktu masuk',
              formatWaktu(sesi.masukPada),
            ),
            const SizedBox(height: 10),
            _barisInfo(
              context,
              'Kedaluwarsa pada',
              formatWaktu(sesi.kedaluwarsaPada),
            ),
            const SizedBox(height: 10),
            _barisInfo(
              context,
              'Sisa masa berlaku',
              formatSisa(sisa),
            ),
            const SizedBox(height: 10),
            _barisInfo(
              context,
              'Token',
              tampilkanToken ? sesi.token : samarkanToken(sesi.token),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: sedangKeluar ? null : onKeluar,
                icon: sedangKeluar
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.logout_rounded),
                label: Text(
                  sedangKeluar ? 'Keluar…' : 'Keluar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barisInfo(
    BuildContext context,
    String judul,
    String nilai,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 145,
          child: Text(
            judul,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            nilai,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}