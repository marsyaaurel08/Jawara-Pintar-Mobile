import 'package:flutter/material.dart';

class AspirasiPage extends StatefulWidget {
  const AspirasiPage({super.key});

  @override
  State<AspirasiPage> createState() => _AspirasiPageState();
}

class _AspirasiPageState extends State<AspirasiPage> {
  // Data dummy untuk contoh
  final List<Map<String, dynamic>> _kegiatanData = [
    {
      'id': 1,
      'pengirim': 'John Doe',
      'judul': 'Rapat Koordinasi Bulanan',
      'status': 'Selesai',
      'tanggal': '2024-01-15',
      'deskripsi': 'Rapat koordinasi untuk membahas progress bulanan'
    },
    {
      'id': 2,
      'pengirim': 'Jane Smith',
      'judul': 'Pelatihan Flutter',
      'status': 'Berlangsung',
      'tanggal': '2024-01-20',
      'deskripsi': 'Pelatihan pengembangan aplikasi mobile dengan Flutter'
    },
    {
      'id': 3,
      'pengirim': 'Bob Johnson',
      'judul': 'Webinar Digital Marketing',
      'status': 'Akan Datang',
      'tanggal': '2024-02-01',
      'deskripsi': 'Webinar tentang strategi digital marketing terbaru'
    },
  ];

  void _showDetailDialog(Map<String, dynamic> kegiatan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(kegiatan['judul']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Pengirim', kegiatan['pengirim']),
                _buildDetailRow('Status', kegiatan['status']),
                _buildDetailRow('Tanggal Dibuat', kegiatan['tanggal']),
                _buildDetailRow('Deskripsi', kegiatan['deskripsi']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('TUTUP'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _editKegiatan(Map<String, dynamic> kegiatan) {
    // Implementasi edit kegiatan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit kegiatan: ${kegiatan['judul']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteKegiatan(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Kegiatan'),
          content: const Text('Apakah Anda yakin ingin menghapus kegiatan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('BATAL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _kegiatanData.removeWhere((item) => item['id'] == id);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kegiatan berhasil dihapus'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kegiatan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header informasi
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tabel menampilkan judul dan aksi. Klik detail untuk informasi lengkap.',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Tabel kegiatan
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) => Colors.grey.shade100,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'No',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Judul Kegiatan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Aksi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: _kegiatanData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final kegiatan = entry.value;
                      
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(
                            Text(
                              kegiatan['judul'],
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye, size: 18),
                                  color: Colors.blue,
                                  onPressed: () => _showDetailDialog(kegiatan),
                                  tooltip: 'Detail',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  color: Colors.orange,
                                  onPressed: () => _editKegiatan(kegiatan),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18),
                                  color: Colors.red,
                                  onPressed: () => _deleteKegiatan(kegiatan['id']),
                                  tooltip: 'Hapus',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}