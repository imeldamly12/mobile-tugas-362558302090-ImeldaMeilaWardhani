import 'package:flutter/material.dart';

// 1. Enum Status Sesi Praktikum
enum SessionStatus { ongoing, upcoming, completed, available }

// 2. Model Data Sesi Praktikum
class PracticumSession {
  final String courseName;
  final String lecturerName;
  final String timeRange;
  final String room;
  final SessionStatus status;
  final String infoText;

  PracticumSession({
    required this.courseName,
    required this.lecturerName,
    required this.timeRange,
    required this.room,
    required this.status,
    required this.infoText,
  });
}

// 4 Data Pengujian Sesuai Acuan Dosen
final List<PracticumSession> sessions = [
  PracticumSession(
    courseName: 'Mobile Programming',
    lecturerName: 'Dr. Ir. Budi Santoso, M.T., Ph.D.',
    timeRange: '08.00 - 10.00',
    room: 'Lab 1',
    status: SessionStatus.ongoing,
    infoText: 'Sedang digunakan oleh praktikan',
  ),
  PracticumSession(
    courseName: 'Rekayasa Perangkat Lunak',
    lecturerName: 'Siti Aminah, S.Kom., M.T.',
    timeRange: '10.00 - 12.00',
    room: 'Lab 2',
    status: SessionStatus.upcoming,
    infoText: 'Sesi akan dimulai sebentar lagi',
  ),
  PracticumSession(
    courseName: 'Basis Data',
    lecturerName: 'Ahmad Fauzi, M.Cs.',
    timeRange: '13.00 - 15.00',
    room: 'Lab 3',
    status: SessionStatus.completed,
    infoText: 'Sesi telah selesai',
  ),
  PracticumSession(
    courseName: 'Lab 2',
    lecturerName: 'Ruang tersedia di luar jadwal sesi',
    timeRange: '-',
    room: 'Lab 2',
    status: SessionStatus.available,
    infoText: 'Siap digunakan untuk praktikum lain',
  ),
];

class RuangPraktikumScreen extends StatelessWidget {
  const RuangPraktikumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int totalSessions = sessions.where((s) => s.status != SessionStatus.available).length;
    final int availableRooms = sessions.where((s) => s.status == SessionStatus.available).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ruang Praktikum Hari Ini',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth >= 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ringkasan Wrap
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _SummaryChip(
                          icon: Icons.calendar_today,
                          label: '$totalSessions sesi',
                          color: Colors.blue.shade50,
                          textColor: Colors.blue.shade800,
                        ),
                        _SummaryChip(
                          icon: Icons.meeting_room,
                          label: '$availableRooms ruang tersedia',
                          color: Colors.green.shade50,
                          textColor: Colors.green.shade800,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Daftar Kartu
                    isWideScreen
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              mainAxisExtent: 155,
                            ),
                            itemCount: sessions.length,
                            itemBuilder: (context, index) {
                              return SessionCard(session: sessions[index]);
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sessions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: SizedBox(
                                  height: 155,
                                  child: SessionCard(session: sessions[index]),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final PracticumSession session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    session.courseName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                _buildStatusBadge(session.status),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              session.lecturerName,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Divider(height: 1, color: Colors.black12),
            ),
            if (session.status != SessionStatus.available) ...[
              Row(
                children: [
                  Icon(Icons.access_time, size: 13, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(session.timeRange, style: TextStyle(fontSize: 11, color: Colors.grey.shade800)),
                  const SizedBox(width: 12),
                  Icon(Icons.location_on, size: 13, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      session.room,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    _getInfoIcon(session.status),
                    size: 13,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      session.infoText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getInfoIcon(SessionStatus status) {
    switch (status) {
      case SessionStatus.ongoing:
        return Icons.group;
      case SessionStatus.upcoming:
        return Icons.access_time_filled;
      case SessionStatus.completed:
        return Icons.check_circle;
      case SessionStatus.available:
        return Icons.meeting_room;
    }
  }

  Widget _buildStatusBadge(SessionStatus status) {
    String text;
    Color bgColor;
    Color textColor;

    switch (status) {
      case SessionStatus.ongoing:
        text = 'Berlangsung';
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case SessionStatus.upcoming:
        text = 'Akan datang';
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case SessionStatus.completed:
        text = 'Selesai';
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        break;
      case SessionStatus.available:
        text = 'Tersedia';
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}