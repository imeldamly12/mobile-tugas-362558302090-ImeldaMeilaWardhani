import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/krs_course.dart';

class KrsNotifier extends Notifier<List<KrsCourse>> {
  @override
  List<KrsCourse> build() {
    return KrsCourse.getInitialCourses();
  }

  // Menambahkan mata kuliah ke KRS
  bool tambahMataKuliah(KrsCourse course) {
    // Cek apakah kode mata kuliah sudah ada
    final exists = state.any(
      (c) => c.code.toUpperCase() == course.code.toUpperCase(),
    );

    if (exists) {
      return false;
    }

    // Maksimal 24 SKS
    if (totalSks + course.sks > 24) {
      return false;
    }

    // Membuat state baru
    state = [...state, course];

    return true;
  }

  // Menghapus mata kuliah dari KRS
  void hapusMataKuliah(String code) {
    state = state.where((c) => c.code != code).toList();
  }

  // Menghitung total SKS
  int get totalSks {
    return state.fold(
      0,
      (sum, course) => sum + course.sks,
    );
  }
}

// Provider utama untuk daftar KRS
final krsProvider =
    NotifierProvider<KrsNotifier, List<KrsCourse>>(
  KrsNotifier.new,
);

// Provider untuk menghitung total SKS
final totalSksProvider = Provider<int>((ref) {
  final courses = ref.watch(krsProvider);

  return courses.fold(
    0,
    (sum, course) => sum + course.sks,
  );
});