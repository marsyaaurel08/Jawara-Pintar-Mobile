import 'package:flutter/material.dart';

class KegiatanPage extends StatelessWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk tabel
    final List<Map<String, String>> dataKegiatan = [
      {
        "no": "1",
        "nama": "Kerja Bakti Bulanan",
        "kategori": "Lingkungan",
        "pj": "Bpk. Taufik",
        "tanggal": "25-10-2025"
      },
      {
        "no": "2",
        "nama": "Lomba 17 Agustus",
        "kategori": "Perlombaan",
        "pj": "Karang Taruna",
        "tanggal": "17-08-2025"
      },
      {
        "no": "3",
        "nama": "Pengajian Rutin",
        "kategori": "Keagamaan",
        "pj": "Bpk. RT",
        "tanggal": "30-10-2025"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kegiatan'),
        backgroundColor: const Color(0xFF26A69A), // Sesuaikan warna
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
                  'Daftar Kegiatan',
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
                      label: const Text('Tambah'),
                      onPressed: () {
                        // TODO: Navigasi ke halaman tambah kegiatan
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26A69A),
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
                    DataColumn(label: Text('Nama Kegiatan')),
                    DataColumn(label: Text('Kategori')),
                    DataColumn(label: Text('PJ')),
                    DataColumn(label: Text('Tanggal')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: dataKegiatan.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['no']!)),
                      DataCell(Text(item['nama']!)),
                      DataCell(Text(item['kategori']!)),
                      DataCell(Text(item['pj']!)),
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