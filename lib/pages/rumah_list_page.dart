import 'package:flutter/material.dart';
// Asumsi path TambahRumahPage yang benar sudah di-import
import '../../pages/tambah_rumah_page.dart';
// Import file detail yang baru
import '../../pages/detail_rumah_page.dart';
import '../../pages/edit_rumah_page.dart';

class RumahListPage extends StatefulWidget {
  const RumahListPage({Key? key}) : super(key: key);

  @override
  State<RumahListPage> createState() => _RumahListPageState();
}

class _RumahListPageState extends State<RumahListPage> {
  // --- Skema Warna Konsisten dengan WargaListPage (Biru Tua) ---
  static const Color _primaryColor = Color(0xFF2E6BFF); // Biru Tua (Deep Blue)
  static const Color _accentColor = Color(
    0xFF00C853,
  ); // Hijau untuk status Tersedia
  static const Color _editColor = Color(0xFFFF9800); // Orange untuk Edit
  static const Color _textColor = Color(
    0xFF37474F,
  ); // Abu-abu gelap (Deep Grey)

  // Penyesuaian Ukuran Font untuk Mobile
  static const double _cardTitleSize = 15.0;
  static const double _cardSubtitleSize = 12.0;

  // --- Data Dummy Rumah (Dibuat final agar bisa dimodifikasi di State) ---
  final List<Map<String, dynamic>> _allRumahList = [
    {
      "id": 1,
      "no_rumah": "1",
      "alamat": "Jl. Merbabu No. 12A",
      "status": "Tersedia",
      "luas": 120,
      "jenis": "Permanen",
      "rt": "001",
      "rw": "01",
      "keluarga": "Keluarga Lainnya",
      "statusKepemilikan": "Pemilik",
      "statusRumah": "Kosong", // Digunakan di Edit Page
    },
    {
      "id": 2,
      "no_rumah": "4",
      "alamat": "Jl. Brawijaya 45",
      "status": "Tersedia",
      "luas": 80,
      "jenis": "Semi Permanen",
      "rt": "004",
      "rw": "02",
      "keluarga": "Keluarga Lainnya",
      "statusKepemilikan": "Pemilik",
      "statusRumah": "Kosong",
    },
    {
      "id": 3,
      "no_rumah": "5",
      "alamat": "Jl. Baru Bangun 17",
      "status": "Ditempati",
      "luas": 100,
      "jenis": "Permanen",
      "penghuni": "Keluarga Anti Micin",
      "rt": "005",
      "rw": "03",
      "keluarga": "Keluarga Anti Micin",
      "statusKepemilikan": "Pinjam Pakai",
      "statusRumah": "Aktif",
    },
  ];

  String _searchQuery = '';
  bool isFilterActive = false; // Status filter sederhana

  // --- FUNGSI NAVIGASI & AKSI BARU ---

  void _navigateToDetail(Map<String, dynamic> rumah) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailRumahPage(rumah: rumah)),
    );
  }

  void _navigateToEdit(BuildContext context, Map<String, dynamic> dataRumah) {
    // Tentukan nilai fallback yang aman dan ada di list opsi EditRumahPage
    final String fallbackKeluarga = 'Keluarga Lainnya';
    final String rawKeluarga = dataRumah['keluarga'] ?? fallbackKeluarga;

    // Jika nilai dari data adalah "Tidak Ada" (atau nilai tidak valid lainnya),
    // ganti dengan nilai fallback yang ada di dropdown list.
    final String selectedKeluarga = (rawKeluarga == 'Tidak Ada')
        ? fallbackKeluarga
        : rawKeluarga;

    final RumahData rumahDipilih = RumahData(
      alamatRumah: dataRumah['alamat'] ?? '',
      rt: dataRumah['rt'] ?? '001',
      rw: dataRumah['rw'] ?? '01',
      keluarga: selectedKeluarga, // <-- GUNAKAN NILAI YANG SUDAH DIPERBAIKI
      statusKepemilikan: dataRumah['statusKepemilikan'] ?? 'Pemilik',
      statusRumah: dataRumah['statusRumah'] ?? 'Aktif',
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditRumahPage(rumahToEdit: rumahDipilih),
      ),
    );
  }

  void _onDeleteRumah(Map<String, dynamic> rumah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Konfirmasi Hapus",
          style: TextStyle(color: Colors.red, fontSize: 16.0),
        ),
        content: Text(
          "Anda yakin ingin menghapus data rumah No. ${rumah['no_rumah']}?",
          style: const TextStyle(fontSize: 14.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Batal",
              style: TextStyle(color: _textColor, fontSize: 14.0),
            ),
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

  // --- FUNGSI FILTER (TETAP SAMA) ---

  void _showFilterDialog(BuildContext context) {
    // ... (Kode Filter Dialog tetap sama) ...
    bool tempFilter = isFilterActive;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Data Rumah'),
        content: StatefulBuilder(
          builder: (context, setStateSB) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter sederhana
              CheckboxListTile(
                value: tempFilter,
                onChanged: (value) => setStateSB(() {
                  tempFilter = value ?? false;
                }),
                title: const Text('Tampilkan hanya status Tersedia'),
              ),
              const Text(
                "Filter ini hanya contoh. Di implementasi nyata, Anda bisa menambahkan filter berdasarkan jenis bangunan atau status lain.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isFilterActive = tempFilter;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredRumahList {
    List<Map<String, dynamic>> list = _allRumahList.where((rumah) {
      final matchesSearch =
          rumah['alamat'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rumah['no_rumah'].contains(_searchQuery);

      final matchesFilter = isFilterActive
          ? (rumah['status'] ==
                'Tersedia') // Contoh: hanya tampilkan yang tersedia
          : true;

      return matchesSearch && matchesFilter;
    }).toList();

    return list;
  }

  // --- Widget pembantu untuk Badge Status (TETAP SAMA) ---
  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(
          5,
        ), // Kotak dengan sudut sedikit membulat
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // --- WIDGET UTAMA: BUILD (LIST PAGE) ---
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Memberi background di luar card
      // Menggunakan AppBar dengan container biru
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(80),
      //   child: AppBar(
      //     backgroundColor: const Color.fromARGB(255, 5, 117, 209),
      //     elevation: 0,
      //     automaticallyImplyLeading: false, // Disable automatic back button
      //     flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: [
      //             const Color.fromARGB(255, 5, 117, 209),
      //             const Color.fromARGB(255, 3, 95, 170),
      //           ],
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //         ),
      //       ),
      //       child: SafeArea(
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Row(
      //                 children: [
      //                   // Back button putih
      //                   IconButton(
      //                     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //                     onPressed: () => Navigator.pop(context),
      //                   ),
      //                   const SizedBox(width: 4),
      //                   // Icon rumah
      //                   Container(
      //                     padding: const EdgeInsets.all(8),
      //                     decoration: BoxDecoration(
      //                       color: Colors.white.withOpacity(0.2),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     child: const Icon(
      //                       Icons.home_outlined,
      //                       color: Colors.white,
      //                       size: 24,
      //                     ),
      //                   ),
      //                   const SizedBox(width: 12),
      //                   const Text(
      //                     'Data Rumah',
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 22,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),

      body: Column(
        children: [
          // Search Bar and Filter Button (TETAP SAMA)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(fontSize: 14.0),
                    decoration: InputDecoration(
                      hintText: 'Cari alamat atau nomor rumah...',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: _primaryColor,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: _primaryColor.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Button Filter
                Container(
                  decoration: BoxDecoration(
                    color: isFilterActive
                        ? _primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: isFilterActive ? Colors.white : Colors.black87,
                      size: 20,
                    ),
                    onPressed: () => _showFilterDialog(context),
                    tooltip: 'Filter Data',
                  ),
                ),
              ],
            ),
          ),

          // Filter Reset Chip (TETAP SAMA)
          if (isFilterActive)
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 6.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ActionChip(
                  avatar: const Icon(
                    Icons.close,
                    color: _primaryColor,
                    size: 16,
                  ),
                  label: const Text(
                    'Filter Aktif: Status Tersedia', // Label disederhanakan
                    style: TextStyle(color: _primaryColor, fontSize: 13),
                  ),
                  onPressed: () {
                    setState(() {
                      isFilterActive = false; // Hanya mereset flag filter rumah
                    });
                  },
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  side: const BorderSide(color: _primaryColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                ),
              ),
            ),

          // Rumah List
          Expanded(
            child: _filteredRumahList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.house_siding_outlined,
                          size: 60,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tidak ada data rumah yang cocok.',
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 80.0,
                    ), // Padding di bawah untuk FAB
                    itemCount: _filteredRumahList.length,
                    itemBuilder: (context, index) {
                      final rumah = _filteredRumahList[index];
                      return _buildRumahCard(rumah);
                    },
                  ),
          ),
        ],
      ),

      // Floating Action Button (TETAP SAMA)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahRumahPage()),
          );
        },
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Rumah',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // WIDGET: Card untuk setiap item rumah (DISESUAIKAN UNTUK IKON EDIT/HAPUS)
  // --------------------------------------------------------------------------
  Widget _buildRumahCard(Map<String, dynamic> rumah) {
    final isTersedia = rumah['status'] == 'Tersedia';
    final statusColor = isTersedia ? _accentColor : _primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5, // Ditingkatkan sedikit untuk efek 'epic'
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Sudut lebih membulat
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(rumah), // Navigasi ke Detail Page
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: ListTile(
            // LEADING: Ikon Rumah
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: statusColor.withOpacity(
                0.1,
              ), // Warna menyesuaikan status
              child: Icon(
                Icons.house_siding_rounded,
                color: statusColor,
                size: 28,
              ),
            ),

            // --- TITLE: Nomor Rumah/Alamat Utama ---
            title: Text(
              "${rumah['alamat']}",
              style: const TextStyle(
                fontWeight: FontWeight.w800, // Ditebalkan
                fontSize: _cardTitleSize + 1, // Ditingkatkan sedikit
                color: _textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),

            // --- SUBTITLE: Detail Info Bawah ---
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                // Luas & Jenis Bangunan
                Row(
                  children: [
                    const Icon(
                      Icons.architecture,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${rumah['jenis']} | Luas: ${rumah['luas']} m²",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: _cardSubtitleSize,
                      ),
                    ),
                  ],
                ),

                // Penghuni (Jika Ditempati)
                if (!isTersedia)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.person_pin_circle,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Penghuni: ${rumah['penghuni'] ?? '-'}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: _cardSubtitleSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 8),

                // Status Badge
                _buildStatusBadge(rumah['status'], statusColor),
              ],
            ),

            // --- TRAILING: Ikon Edit dan Hapus (Pengganti Titik Tiga) ---
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Edit
                IconButton(
                  icon: const Icon(
                    Icons.edit_note_rounded, // Ikon edit dengan pena
                    color: _primaryColor,
                    size: 26,
                  ),
                  onPressed: () => _navigateToEdit(context, rumah),
                  tooltip: 'Edit Data Rumah',
                ),
                // Icon Hapus
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever_rounded, // Ikon hapus yang tegas
                    color: Colors.red,
                    size: 26,
                  ),
                  onPressed: () => _onDeleteRumah(rumah),
                  tooltip: 'Hapus Data Rumah',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
