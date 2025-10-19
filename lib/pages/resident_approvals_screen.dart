import 'package:flutter/material.dart';

// --- Model Data (Untuk simulasi) ---
class ApprovalItem {
  final int no;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin;
  final String fotoIdentitasUrl;
  final String statusRegistrasi;

  ApprovalItem({
    required this.no,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.fotoIdentitasUrl,
    required this.statusRegistrasi,
  });
}

// Data simulasi berdasarkan gambar
final List<ApprovalItem> mockData = [
  ApprovalItem(
    no: 1,
    nama: 'Farhan',
    nik: '4567890864354356',
    email: 'farhan@gmail.com',
    jenisKelamin: 'Laki-laki',
    fotoIdentitasUrl: '', // Tidak ada foto
    statusRegistrasi: 'Diterima',
  ),
  ApprovalItem(
    no: 2,
    nama: 'Rendha Putra Rahmadya',
    nik: '3505111512040002',
    email: 'rendhazuper@gmail.com',
    jenisKelamin: 'Laki-laki',
    // Ganti dengan URL gambar sebenarnya
    fotoIdentitasUrl: 'https://picsum.photos/seed/rendha/100',
    statusRegistrasi: 'Diterima',
  ),
  ApprovalItem(
    no: 3,
    nama: 'Anti Micin',
    nik: '1234567890987654',
    email: 'antimicin3@gmail.com',
    jenisKelamin: 'Laki-laki',
    // Ganti dengan URL gambar sebenarnya
    fotoIdentitasUrl: 'https://picsum.photos/seed/anti/100',
    statusRegistrasi: 'Diterima',
  ),
  ApprovalItem(
    no: 4,
    nama: 'Iijat',
    nik: '2025202520252025',
    email: 'iijat1@gmail.com',
    jenisKelamin: 'Laki-laki',
    // Ganti dengan URL gambar sebenarnya
    fotoIdentitasUrl: 'https://picsum.photos/seed/iijat/100',
    statusRegistrasi: 'Nonaktif',
  ),
];

class ResidentApprovalsScreen extends StatelessWidget {
  const ResidentApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerimaan Warga'),
        backgroundColor: const Color(
          0xFF7E57C2,
        ), // Warna sesuai fitur Penerimaan
        actions: [
          // Filter Button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Aksi filter
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: mockData.length,
        itemBuilder: (context, index) {
          final item = mockData[index];
          return _buildApprovalCard(context, item);
        },
      ),
    );
  }

  // --- Widget untuk Status Registrasi ---
  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Diterima':
        color = Colors.green.shade600;
        icon = Icons.check_circle_outline;
        break;
      case 'Nonaktif':
        color = Colors.red.shade600;
        icon = Icons.cancel_outlined;
        break;
      default:
        color = Colors.orange.shade600;
        icon = Icons.access_time;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // --- Card untuk setiap data warga ---
  Widget _buildApprovalCard(BuildContext context, ApprovalItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARIS 1: Nama, Status, dan Aksi
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF7E57C2),
                child: Text(
                  item.no.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                item.nama,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7E57C2),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildStatusChip(item.statusRegistrasi),
                    // Tombol Aksi (More options)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle aksi (Detail, Setuju, Tolak)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Aksi ${item.nama}: $value')),
                        );
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Detail',
                              child: Text('Lihat Detail'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Setuju',
                              child: Text('Setujui'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Tolak',
                              child: Text('Tolak'),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            const SizedBox(height: 8),

            // BARIS 2: Detail Data (NIK, Email, JK)
            _buildDetailRow(
              icon: Icons.credit_card,
              label: 'NIK',
              value: item.nik,
            ),
            _buildDetailRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: item.email,
            ),
            _buildDetailRow(
              icon: Icons.person_outline,
              label: 'Jenis Kelamin',
              value: item.jenisKelamin,
            ),

            // BARIS 3: Foto Identitas
            const SizedBox(height: 8),
            if (item.fotoIdentitasUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Foto Identitas',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    // Tampilkan gambar dari URL
                    SizedBox(
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item.fotoIdentitasUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                        ),
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

  // Helper widget untuk baris detail
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Contoh penggunaan (opsional, untuk menjalankan preview) ---
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penerimaan Warga Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: false,
      ),
      home: const ResidentApprovalsScreen(),
    );
  }
}
*/
