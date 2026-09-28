import '../datasources/announcement_remote_datasource.dart';
import '../models/announcement.dart';
import 'announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl({
    AnnouncementRemoteDatasource? datasource,
  }) : _datasource = datasource ?? AnnouncementRemoteDatasource();

  final AnnouncementRemoteDatasource _datasource;

  @override
  Future<List<Announcement>> getAnnouncements({
    String? category,
  }) async {
    final List<Announcement> announcements =
        await _datasource.getAnnouncements();

    if (category == null ||
        category.isEmpty ||
        category == 'Semua') {
      return announcements;
    }

    return announcements
        .where(
          (Announcement item) =>
              item.category.toLowerCase() ==
              category.toLowerCase(),
        )
        .toList();
  }

  @override
  Future<Announcement> addAnnouncement(
    Announcement announcement,
  ) async {
    return announcement;
  }
}