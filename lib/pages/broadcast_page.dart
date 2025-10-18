import 'package:flutter/material.dart';

class BroadcastPage extends StatelessWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk tabel
    final List<Map<String, String>> dataBroadcast = [
      {
        "no": "1",
        "pengirim": "Admin RT",
        "judul": "Pemberitahuan Kerja Bakti",
        "tanggal": "20-10-2025"
      },
      {
        "no": "2",
        "pengirim": "Admin RT",
        "judul": "Undangan Rapat Warga",
        "tanggal": "15-10-2025"
      },
      {
        "no": "3",
        "pengirim": "Admin RW",
        "judul": "Info Keamanan Lingkungan",
        "tanggal": "12-10-2025"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Broadcast'),
        backgroundColor: const Color(0xFF42A5F5), // Sesuaikan warna
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
                  'Daftar Broadcast',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      tooltip: 'Filter',
                      onPressed: () {
                        // TODO: Logika untuk filter
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Buat Baru'),
                      onPressed: () {
                        // TODO: Navigasi ke halaman tambah broadcast
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
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
                    DataColumn(label: Text('Tanggal')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: dataBroadcast.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['no']!)),
                      DataCell(Text(item['pengirim']!)),
                      DataCell(Text(item['judul']!)),
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
                            tooltip: 'Edit',
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