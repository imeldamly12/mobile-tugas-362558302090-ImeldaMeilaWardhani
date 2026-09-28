import 'package:dio/dio.dart';

import '../models/announcement.dart';

class AnnouncementRemoteDatasource {
  AnnouncementRemoteDatasource({
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://jsonplaceholder.typicode.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio _dio;

  Future<List<Announcement>> getAnnouncements() async {
    final Response<dynamic> response = await _dio.get(
      '/posts',
      queryParameters: <String, dynamic>{
        '_limit': 10,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map(
          (dynamic item) =>
              Announcement.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}