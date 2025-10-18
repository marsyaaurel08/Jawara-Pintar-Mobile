import 'package:flutter/material.dart';

class AspirasiPage extends StatelessWidget {
  const AspirasiPage({super.key});

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'Diterima':
        color = Colors.blue;
        label = 'Diterima';
        break;
      case 'Diproses':
        color = Colors.orange;
        label = 'Diproses';
        break;
      case 'Selesai':
        color = Colors.green;
        label = 'Selesai';
        break;
      default:
        color = Colors.grey;
        label = 'Baru';
    }
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk tabel
    final List<Map<String, String>> dataAspirasi = [
      {
        "no": "1",
        "pengirim": "Warga Anonim",
        "judul": "Lampu jalan di RT 05 mati",
        "status": "Diproses",
        "tanggal": "18-10-2025"
      },
      {
        "no": "2",
        "pengirim": "Bpk. Budi",
        "judul": "Usulan perbaikan jalan",
        "status": "Diterima",
        "tanggal": "17-10-2025"
      },
      {
        "no": "3",
        "pengirim": "Ibu Siti",
        "judul": "Masalah sampah di depan gang",
        "status": "Selesai",
        "tanggal": "10-10-2025"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Aspirasi'),
        backgroundColor: const Color(0xFF8D6E63), // Sesuaikan warna
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== HEADER & TOMBOL AKSI ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Aspirasi Warga',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter',
                  onPressed: () {
                    // TODO: Logika untuk filter
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ====== TABEL DATA ======
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Pengirim')),
                    DataColumn(label: Text('Judul')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Tanggal')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: dataAspirasi.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['no']!)),
                      DataCell(Text(item['pengirim']!)),
                      DataCell(SizedBox(width: 150, child: Text(item['judul']!, overflow: TextOverflow.ellipsis))),
                      DataCell(_buildStatusChip(item['status']!)),
                      DataCell(Text(item['tanggal']!)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility, size: 20),
                            tooltip: 'Detail',
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                            tooltip: 'Ubah Status',
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                            tooltip: 'Hapus',
                            onPressed: () {},
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}