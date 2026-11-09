import 'dart:io';
import 'domain/aturan_bau.dart';

class Temuan {
  final AturanBau aturan;
  final String namaBerkas;
  final int baris;
  final String cuplikan;

  Temuan(this.aturan, this.namaBerkas, this.baris, this.cuplikan);
}

void main(List<String> args) async {
  final folderPath = args.isNotEmpty ? args[0] : 'lib/modul_09/data';
  final folder = Directory(folderPath);

  if (!folder.existsSync()) {
    print('GAGAL: Folder "$folderPath" tidak ditemukan.');
    return;
  }

  final daftarTemuan = <Temuan>[];
  int totalBerkas = 0;

  await for (final entity in folder.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      totalBerkas++;
      final lines = await entity.readAsLines();
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        final barisKe = i + 1;

        if (line.contains('abaikan-ai:')) continue;

        if (RegExp(r'\w+!;').hasMatch(line) && !line.contains('!=') && !line.contains('!(')) {
          daftarTemuan.add(Temuan(AturanBau.nullAssertionTanpaJustifikasi, entity.path, barisKe, line.trim()));
        }

        if (line.contains('TextEditingController()') || line.contains('ScrollController()') || line.contains('AnimationController(')) {
          final namaVariabel = line.split(' ').last.replaceAll('()', '').replaceAll(';', '').trim();
          final seluruhTeks = lines.join('\n');
          if (!seluruhTeks.contains('$namaVariabel.dispose()')) {
            daftarTemuan.add(Temuan(AturanBau.controllerTanpaDispose, entity.path, barisKe, line.trim()));
          }
        }

        if (line.trim() == 'setState(() {' && i > 0) {
          for (int j = i - 1; j >= 0; j--) {
            if (lines[j].contains('await ')) {
              if (!lines[j].contains('mounted')) {
                daftarTemuan.add(Temuan(AturanBau.setStateSetelahAwait, entity.path, barisKe, line.trim()));
              }
              break;
            }
            if (lines[j].contains('void ') || lines[j].contains('Future')) break;
          }
        }

        if (line.contains('withOpacity(')) {
          daftarTemuan.add(Temuan(AturanBau.apiDeprecated, entity.path, barisKe, line.trim()));
        }

        if (RegExp(r'apiKey\s*=\s*[\x27"].*[\x27"]').hasMatch(line) || RegExp(r'token\s*=\s*[\x27"].*[\x27"]').hasMatch(line)) {
          daftarTemuan.add(Temuan(AturanBau.kredensialKeras, entity.path, barisKe, line.trim()));
        }

        if (line.contains('print(') && !line.contains('debugPrint(')) {
          daftarTemuan.add(Temuan(AturanBau.printBukanDebugPrint, entity.path, barisKe, line.trim()));
        }

        if (line.contains('catch (') && line.trim().endsWith('{')) {
          if (i + 1 < lines.length && lines[i + 1].trim() == '}') {
            daftarTemuan.add(Temuan(AturanBau.catchKosong, entity.path, barisKe, line.trim()));
          }
        }
      }
    }
  }

  print('Memeriksa $totalBerkas berkas...\n');
  int kritis = 0, serius = 0, ringan = 0;

  for (var t in daftarTemuan) {
    print('${t.aturan.kode} | baris ${t.baris} | [${t.aturan.tingkat.name.toUpperCase()}] ${t.aturan.judul}');
    print('   Cuplikan: ${t.cuplikan}');
    print('   Batas   : ${t.aturan.keterbatasan}\n');

    if (t.aturan.tingkat.name == 'kritis') kritis++;
    if (t.aturan.tingkat.name == 'serius') serius++;
    if (t.aturan.tingkat.name == 'ringan') ringan++;
  }

  print('--- RINGKASAN ---');
  print('Total Temuan: ${daftarTemuan.length} (Kritis: $kritis, Serius: $serius, Ringan: $ringan)');
  if (daftarTemuan.isEmpty) {
    print('Tidak ada pelanggaran terdeteksi. Ini bukan bukti kode sudah benar — tinjau manual tetap wajib.');
  } else {
    print('KODE TIDAK BOLEH DIGABUNGKAN SEBELUM DIPERBAIKI.');
  }
}