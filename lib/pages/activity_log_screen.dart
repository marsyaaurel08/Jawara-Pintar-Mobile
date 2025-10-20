import 'package:flutter/material.dart';

// ----------------------------------------------------------------------
// 1. DATA MODEL
// ----------------------------------------------------------------------

// Jenis aktivitas untuk menentukan warna dan ikon (untuk UI yang bagus)
enum ActivityType {
  dataAdded,
  dataUpdated,
  dataDeleted,
  approval,
  taskAssigned,
  download,
  broadcast,
  unknown,
}

class ActivityLog {
  final String description;
  final String actor;
  final String date;
  final ActivityType type;

  ActivityLog({
    required this.description,
    required this.actor,
    required this.date,
    required this.type,
  });
}

// Data Dummy (Berdasarkan referensi tabel log)
final List<ActivityLog> dummyLogs = [
  ActivityLog(
    description: 'Menambahkan iuran baru: Harian',
    actor: 'Admin Jawara',
    date: '19 Oktober 2025',
    type: ActivityType.dataAdded,
  ),
  ActivityLog(
    description: 'Menambahkan iuran baru: Kerja Bakti',
    actor: 'Admin Jawara',
    date: '19 Oktober 2025',
    type: ActivityType.dataAdded,
  ),
  ActivityLog(
    description: 'Mendownload laporan keuangan',
    actor: 'Admin Jawara',
    date: '19 Oktober 2025',
    type: ActivityType.download,
  ),
  ActivityLog(
    description: 'Menyetujui registrasi dari : Keluarga Farhan',
    actor: 'Admin Jawara',
    date: '19 Oktober 2025',
    type: ActivityType.approval,
  ),
  ActivityLog(
    description:
        'Menugaskan tagihan : Mingguan periode Oktober 2025 sebesar Rp. 12',
    actor: 'Admin Jawara',
    date: '18 Oktober 2025',
    type: ActivityType.taskAssigned,
  ),
  ActivityLog(
    description: 'Menghapus transfer channel: Bank Mega',
    actor: 'Admin Jawara',
    date: '18 Oktober 2025',
    type: ActivityType.dataDeleted,
  ),
  ActivityLog(
    description: 'Menambahkan rumah baru dengan alamat: Jl. Merbabu',
    actor: 'Admin Jawara',
    date: '18 Oktober 2025',
    type: ActivityType.dataAdded,
  ),
  ActivityLog(
    description: 'Mengubah iuran: Agustusan',
    actor: 'Admin Jawara',
    date: '17 Oktober 2025',
    type: ActivityType.dataUpdated,
  ),
  ActivityLog(
    description: 'Membuat broadcast baru: DJ BAWS',
    actor: 'Admin Jawara',
    date: '17 Oktober 2025',
    type: ActivityType.broadcast,
  ),
  ActivityLog(
    description: 'Menambahkan pengeluaran : Arka sebesar Rp. 6',
    actor: 'Admin Jawara',
    date: '17 Oktober 2025',
    type: ActivityType.dataAdded,
  ),
];

// ----------------------------------------------------------------------
// 2. WIDGET ITEM LOG (ActivityLogTile)
// ----------------------------------------------------------------------

class ActivityLogTile extends StatelessWidget {
  final ActivityLog log;

  const ActivityLogTile({super.key, required this.log});

  // Fungsi untuk mendapatkan warna berdasarkan tipe aktivitas
  Color _getColor(ActivityType type) {
    switch (type) {
      case ActivityType.dataAdded:
        return Colors.green.shade600;
      case ActivityType.dataUpdated:
        return Colors.blue.shade600;
      case ActivityType.dataDeleted:
        return Colors.red.shade600;
      case ActivityType.approval:
        return Colors.purple.shade600;
      case ActivityType.taskAssigned:
        return Colors.orange.shade600;
      case ActivityType.download:
        return Colors.cyan.shade600;
      case ActivityType.broadcast:
        return Colors.pink.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  // Fungsi untuk mendapatkan ikon berdasarkan tipe aktivitas
  IconData _getIcon(ActivityType type) {
    switch (type) {
      case ActivityType.dataAdded:
        return Icons.add_circle_outline;
      case ActivityType.dataUpdated:
        return Icons.edit_note;
      case ActivityType.dataDeleted:
        return Icons.delete_outline;
      case ActivityType.approval:
        return Icons.check_circle_outline;
      case ActivityType.taskAssigned:
        return Icons.assignment_turned_in_outlined;
      case ActivityType.download:
        return Icons.download_outlined;
      case ActivityType.broadcast:
        return Icons.campaign_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(log.type);
    final icon = _getIcon(log.type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Aksi
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),

          // Deskripsi, Aktor, dan Tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Deskripsi Aktivitas
                Text(
                  log.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),

                // Baris Aktor dan Tanggal
                Row(
                  children: [
                    // Aktor
                    Text(
                      'Oleh: ${log.actor}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Pembatas
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tanggal
                    Text(
                      log.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 3. MAIN SCREEN (ActivityLogScreen)
// ----------------------------------------------------------------------

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 5, 117, 209),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 117, 209),
                  Color.fromARGB(255, 3, 95, 170),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.history_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Log Aktivitas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // Daftar Log Aktivitas
          Expanded(
            child: ListView.builder(
              itemCount: dummyLogs.length,
              itemBuilder: (context, index) {
                return ActivityLogTile(log: dummyLogs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
