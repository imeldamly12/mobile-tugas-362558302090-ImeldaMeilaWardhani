import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/announcement.dart';
import '../repositories/announcement_repository.dart';
import '../repositories/announcement_repository_impl.dart';

final announcementRepositoryProvider =
    Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepositoryImpl();
});

final selectedCategoryProvider =
    StateProvider<String>((ref) {
  return 'Semua';
});

final announcementsProvider =
    FutureProvider<List<Announcement>>((ref) async {
  final AnnouncementRepository repository =
      ref.watch(announcementRepositoryProvider);

  final String category =
      ref.watch(selectedCategoryProvider);

  return repository.getAnnouncements(
    category: category,
  );
});