import 'package:flutter/material.dart';
// Asumsi path TambahRumahPage yang benar sudah di-import
import '../../pages/tambah_rumah_page.dart'; 

class RumahListPage extends StatefulWidget {
  const RumahListPage({Key? key}) : super(key: key);

  @override
  State<RumahListPage> createState() => _RumahListPageState();
}

class _RumahListPageState extends State<RumahListPage> {
  // --- Skema Warna Soft dan Nyaman (Mint/Teal) ---
  static const Color _primaryColor = Color(0xFF00BFA6); // Teal/Mint yang lembut
  static const Color _lightColor = Color(0xFFE0F7FA);   // Background soft
  static const Color _textColor = Color(0xFF37474F);    // Abu-abu gelap
  
  // Penyesuaian Ukuran Font untuk Mobile
  static const double _appBarTitleSize = 18.0;
  static const double _cardTitleSize = 15.0; // Alamat rumah
  static const double _cardSubtitleSize = 11.0; // Penghuni/status

  // --- Data Dummy Rumah ---
  final List<Map<String, dynamic>> _allRumahList = [
    {
      "id": 1,
      "no_rumah": "1",
      "alamat": "Jl. Merbabu No. 12A",
      "status": "Tersedia",
      "luas": 120,
      "jenis": "Permanen",
    },
    {
      "id": 2,
      "no_rumah": "2",
      "alamat": "Malang Indah Blok C-5",
      "status": "Ditempati",
      "luas": 90,
      "jenis": "Semi Permanen",
      "penghuni": "Keluarga Farhan Aditia",
      "riwayat": [
        {"nama": "Keluarga Budi Santoso", "periode": "2018 - 2021"},
      ],
    },
    {
      "id": 3,
      "no_rumah": "3",
      "alamat": "Griyashanta L.203",
      "status": "Ditempati",
      "luas": 150,
      "jenis": "Permanen",
      "penghuni": "Keluarga Rendha Putra",
      "riwayat": [
        {"nama": "Keluarga Siti Aminah", "periode": "2015 - 2017"},
        {"nama": "Keluarga John Doe", "periode": "2010 - 2014"},
      ],
    },
    {
      "id": 4,
      "no_rumah": "4",
      "alamat": "Jl. Brawijaya 45",
      "status": "Tersedia",
      "luas": 80,
      "jenis": "Semi Permanen",
    },
    {
      "id": 5,
      "no_rumah": "5",
      "alamat": "Jl. Baru Bangun 17",
      "status": "Ditempati",
      "luas": 100,
      "jenis": "Permanen",
      "penghuni": "Keluarga Anti Micin",
    },
  ];

  // --- State Variables & Filter Logic (TIDAK BERUBAH) ---
  String _searchQuery = '';
  
  List<Map<String, dynamic>> get _filteredRumahList {
    return _allRumahList.where((rumah) {
      final matchesSearch = rumah['alamat']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          rumah['no_rumah'].contains(_searchQuery);
      return matchesSearch;
    }).toList();
  }

  // --------------------------------------------------------------------------
  // --- FUNGSI UTILITY: Dialog & Aksi (DISESUAIKAN FONT) ---
  // --------------------------------------------------------------------------

  // FUNGSI BARU: Menampilkan Dialog Detail Rumah (menggantikan halaman navigasi)
  void _showDetailDialog(BuildContext context, Map<String, dynamic> rumah) {
    final statusColor = rumah['status'] == 'Tersedia' ? Colors.green.shade700 : Colors.blue.shade700;
    final List<Map<String, String>> riwayatPenghuni = (rumah['riwayat'] as List<dynamic>?)?.cast<Map<String, String>>() ?? [];

    Widget _buildDetailRow(String label, String value, {Color color = _textColor, double valueSize = 14.0}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140, 
              child: Text("$label:",
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 13.0)),
            ),
            Expanded(
              child: Text(value,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: valueSize)),
            ),
          ],
        ),
      );
    }
    
    // Helper untuk Riwayat Penghuni di dalam dialog
    Widget _buildRiwayatSection() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                "Riwayat Penghuni",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0, color: _primaryColor),
              ),
            ),
            const Divider(height: 10, thickness: 0.5),
            if (riwayatPenghuni.isEmpty)
              const Text(
                "Belum ada riwayat penghuni.",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13.0),
              )
            else
              ...riwayatPenghuni.map((riwayat) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          riwayat['nama']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: _textColor, fontSize: 14.0),
                        ),
                        Text(
                          "Periode: ${riwayat['periode']}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ],
                    ),
                  )).toList(),
          ],
        );
    }


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Detail Rumah",
            style: const TextStyle(fontWeight: FontWeight.bold, color: _primaryColor, fontSize: 16.0),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Bagian Detail Rumah
                _buildDetailRow("Nomor Rumah", rumah['no_rumah'] ?? 'N/A', valueSize: 14.0),
                _buildDetailRow("Alamat", rumah['alamat'] ?? 'N/A', valueSize: 14.0),
                _buildDetailRow("Status", rumah['status'] ?? 'N/A', color: statusColor, valueSize: 14.0),
                
                const Divider(height: 16),
                _buildDetailRow("Jenis Bangunan", rumah['jenis'] ?? 'N/A'),
                _buildDetailRow("Luas (m²)", "${rumah['luas'] ?? 'N/A'}"),
                if (rumah['status'] == 'Ditempati')
                  _buildDetailRow("Penghuni Saat Ini", rumah['penghuni'] ?? '-'),

                // Bagian Riwayat Penghuni
                _buildRiwayatSection(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('TUTUP', style: TextStyle(color: _primaryColor, fontSize: 14.0)),
            ),
          ],
        );
      },
    );
  }

  // FUNGSI: Aksi Menu (Detail, Edit, Hapus) - (TIDAK BERUBAH)
  void _handleMenuAction(
      String action, BuildContext context, Map<String, dynamic> rumah) {
    switch (action) {
      case 'Detail':
        _showDetailDialog(context, rumah);
        break;
      case 'Edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Navigasi ke Edit Rumah No. ${rumah['no_rumah']}")),
        );
        break;
      case 'Hapus':
        _showDeleteConfirmation(context, rumah);
        break;
    }
  }

  // FUNGSI: Konfirmasi Hapus (TIDAK BERUBAH)
  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> rumah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus", style: TextStyle(color: Colors.red, fontSize: 16.0)),
        content: Text("Anda yakin ingin menghapus data rumah No. ${rumah['no_rumah']}?", style: const TextStyle(fontSize: 14.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal", style: TextStyle(color: _textColor, fontSize: 14.0)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _allRumahList.removeWhere((item) => item['id'] == rumah['id']);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Data rumah berhasil dihapus!")),
              );
            },
            child: const Text("Hapus", style: TextStyle(fontSize: 14.0)),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // --- WIDGET UTAMA: BUILD (DISESUAIKAN FONT) ---
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Data Rumah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _appBarTitleSize)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementasi Dialog Filter
            },
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(fontSize: 14.0),
              decoration: InputDecoration(
                hintText: 'Cari alamat atau nomor rumah...',
                prefixIcon: const Icon(Icons.search, color: _primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: _lightColor.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              ),
            ),
          ),

          // Rumah List
          Expanded(
            child: _filteredRumahList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada data rumah yang cocok.',
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredRumahList.length,
                    itemBuilder: (context, index) {
                      final rumah = _filteredRumahList[index];
                      final statusColor = rumah['status'] == 'Tersedia' ? Colors.green.shade600 : Colors.blue.shade600;

                      return _buildRumahCard(rumah, index + 1, statusColor);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah rumah
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahRumahPage()),
          );
        },
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Rumah Baru',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // WIDGET: Card untuk setiap item rumah
  Widget _buildRumahCard(
      Map<String, dynamic> rumah, int noUrut, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell( // Menggunakan InkWell untuk aksi tap (Detail)
        onTap: () => _handleMenuAction('Detail', context, rumah),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Nomor Urut
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  '$noUrut',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0, // Font sedang
                    color: _textColor,
                  ),
                ),
              ),
              const VerticalDivider(width: 10),

              // 2. Konten Utama (Alamat & Status)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alamat
                    Text(
                      rumah['alamat'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: _cardTitleSize, // Font Alamat
                        color: _textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Status (Chip)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rumah['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: _cardSubtitleSize, // Font kecil untuk status
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                     // Penghuni (Jika Ditempati)
                    if (rumah['status'] == 'Ditempati')
                    Text(
                      "Penghuni: ${rumah['penghuni'] ?? '-'}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: _cardSubtitleSize, // Font kecil untuk penghuni
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Ikon Menu Aksi
              PopupMenuButton<String>(
                onSelected: (action) => _handleMenuAction(action, context, rumah),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Detail',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: _primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text('Detail', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text('Edit', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Hapus',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: _textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}