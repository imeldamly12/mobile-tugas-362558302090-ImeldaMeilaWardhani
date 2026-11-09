

enum TingkatBahaya { kritis, serius, ringan }

enum AturanBau {
  nullAssertionTanpaJustifikasi(
    kode: 'AI-01',
    judul: 'Null-assertion (!) tanpa pemeriksaan',
    tingkat: TingkatBahaya.kritis,
    keterbatasan: 'Hanya memeriksa satu baris. Bila null sudah diperiksa di baris sebelumnya, temuan ini bisa keliru (positif palsu).',
  ),
  controllerTanpaDispose(
    kode: 'AI-02',
    judul: 'Controller / subscription tanpa dispose()',
    tingkat: TingkatBahaya.kritis,
    keterbatasan: 'Tidak menandai sumber daya yang diterima lewat konstruktor (dianggap dipinjam).',
  ),
  setStateSetelahAwait(
    kode: 'AI-03',
    judul: 'setState() setelah await tanpa cek mounted',
    tingkat: TingkatBahaya.kritis,
    keterbatasan: 'Mungkin gagal mendeteksi jika pemanggilan setState dipisah ke method lain.',
  ),
  apiDeprecated(
    kode: 'AI-04',
    judul: 'API yang sudah deprecated',
    tingkat: TingkatBahaya.serius,
    keterbatasan: 'Daftar API deprecated di-hardcode. Mungkin tertinggal jika Flutter update.',
  ),
  kredensialKeras(
    kode: 'AI-05',
    judul: 'Kredensial ditulis langsung di kode',
    tingkat: TingkatBahaya.kritis,
    keterbatasan: 'Hanya mendeteksi pola nama variabel umum (apiKey, token, dll).',
  ),
  printBukanDebugPrint(
    kode: 'AI-06',
    judul: 'print() alih-alih debugPrint()',
    tingkat: TingkatBahaya.ringan,
    keterbatasan: 'Mungkin salah menandai jika print() memang dipakai untuk CLI tool.',
  ),
  catchKosong(
    kode: 'AI-07',
    judul: 'catch kosong yang menelan error',
    tingkat: TingkatBahaya.serius,
    keterbatasan: 'Blok catch yang hanya berisi komentar tidak ditandai.',
  );

  final String kode;
  final String judul;
  final TingkatBahaya tingkat;
  final String keterbatasan;

  const AturanBau({
    required this.kode,
    required this.judul,
    required this.tingkat,
    required this.keterbatasan,
  });
}