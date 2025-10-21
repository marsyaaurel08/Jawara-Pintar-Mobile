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

  // Penyesuaian Ukuran Font untuk Mobile (Disesuaikan)
  static const double _cardTitleSize = 14.5; // Sedikit lebih kecil dari 15.0
  static const double _cardSubtitleSize = 11.0; // Lebih kecil dari 12.0

  // --- Data Dummy Rumah (Dibuat final agar bisa dimodifikasi di State) ---
  final List<Map<String, dynamic>> _allRumahList = [
    {
      "id": 1,
      "no_rumah": "1",
      "alamat": "Jl. Merbabu No. 12A, RT 001 / RW 01, Kelurahan Pegunungan",
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
      "alamat":
          "Jl. Brawijaya 45, Komplek Perumahan Indah Sekali Dengan Nama Yang Sangat Panjang", // Alamat panjang untuk testing overflow
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
      "alamat": "Jl. Baru Bangun 17, Gg. Melati 3",
      "status": "Ditempati",
      "luas": 100,
      "jenis": "Permanen",
      "penghuni":
          "Keluarga Anti Micin Yang Super Duper Panjang Banget Sampai Tiga Baris Lebih", // Penghuni panjang untuk testing overflow
      "rt": "005",
      "rw": "03",
      "keluarga": "Keluarga Anti Micin",
      "statusKepemilikan": "Pinjam Pakai",
      "statusRumah": "Aktif",
    },
  ];

  String _searchQuery = '';
  bool isFilterActive = false; // Status filter sederhana

  // --- FUNGSI NAVIGASI & AKSI BARU (TIDAK BERUBAH) ---

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

    // Asumsi: RumahData adalah kelas model di EditRumahPage
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

  // --- FUNGSI FILTER (TIDAK BERUBAH) ---

  void _showFilterDialog(BuildContext context) {
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
          ? (rumah['status'] == 'Tersedia') // Contoh: hanya tampilkan yang tersedia
          : true;

      return matchesSearch && matchesFilter;
    }).toList();

    return list;
  }

  // --- Widget pembantu untuk Badge Status (Hanya merubah padding) ---
  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 7, vertical: 3), // Padding sedikit dikurangi
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(
          5,
        ),
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

      body: Column(
        children: [
          // Search Bar and Filter Button (TIDAK BERUBAH)
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
                    color: isFilterActive ? _primaryColor : Colors.grey.shade300,
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

          // Filter Reset Chip (TIDAK BERUBAH)
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
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      // PERBAIKAN: Padding bawah ditingkatkan untuk menghindari bottom overflow
                      bottom: 100.0,
                    ),
                    itemCount: _filteredRumahList.length,
                    itemBuilder: (context, index) {
                      final rumah = _filteredRumahList[index];
                      return _buildRumahCard(rumah);
                    },
                  ),
          ),
        ],
      ),

      // Floating Action Button (TIDAK BERUBAH)
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
  // WIDGET: Card untuk setiap item rumah (Penyesuaian Ukuran & Perbaikan Overflow)
  // --------------------------------------------------------------------------
  Widget _buildRumahCard(Map<String, dynamic> rumah) {
    final isTersedia = rumah['status'] == 'Tersedia';
    final statusColor = isTersedia ? _accentColor : _primaryColor;

    return Card(
      margin:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Margin vertikal dikurangi (dari 8)
      elevation: 4, // Elevation dikurangi (dari 5)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Radius dikurangi (dari 15)
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(rumah),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 8.0), // Padding vertikal dikurangi
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 4.0), // Tambah content padding
            // LEADING: Ikon Rumah
            leading: CircleAvatar(
              radius: 22, // Radius dikurangi (dari 24)
              backgroundColor: statusColor.withOpacity(
                0.1,
              ),
              child: Icon(
                Icons.house_siding_rounded,
                color: statusColor,
                size: 26, // Ukuran ikon dikurangi (dari 28)
              ),
            ),

            // --- TITLE: Nomor Rumah/Alamat Utama (Sudah Diatasi Overflow) ---
            title: Text(
              "${rumah['alamat']}",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: _cardTitleSize, // Menggunakan ukuran yang sudah disesuaikan
                color: _textColor,
              ),
              // PERBAIKAN: Title adalah bagian utama yang cenderung overflow
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),

            // --- SUBTITLE: Detail Info Bawah ---
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5), // Tinggi dikurangi (dari 6)
                // Luas & Jenis Bangunan
                Row(
                  children: [
                    const Icon(
                      Icons.architecture,
                      size: 13, // Ukuran ikon dikurangi (dari 14)
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4), // Lebar dikurangi (dari 5)
                    Expanded( // Diberi Expanded agar tidak overflow jika teks jenis atau luas sangat panjang
                      child: Text(
                        "${rumah['jenis']} | Luas: ${rumah['luas']} m²",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: _cardSubtitleSize, // Menggunakan ukuran yang sudah disesuaikan
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Penghuni (Jika Ditempati)
                if (!isTersedia)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 3.0), // Padding dikurangi (dari 4)
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.person_pin_circle,
                          size: 13, // Ukuran ikon dikurangi (dari 14)
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4), // Lebar dikurangi (dari 5)
                        // 💥 PERBAIKAN PENTING DI SINI: Wrap teks Penghuni dengan Expanded
                        Expanded(
                          child: Text(
                            "Penghuni: ${rumah['penghuni'] ?? '-'}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize:
                                  _cardSubtitleSize, // Menggunakan ukuran yang sudah disesuaikan
                            ),
                            // Mencegah overflow pada nama penghuni yang panjang
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 6), // Tinggi dikurangi (dari 8)

                // Status Badge
                _buildStatusBadge(rumah['status'], statusColor),
              ],
            ),

            // --- TRAILING: Ikon Edit dan Hapus (Penyesuaian Ukuran & Padding) ---
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Edit
                IconButton(
                  icon: const Icon(
                    Icons.edit_note_rounded,
                    color: _primaryColor,
                    size: 24, // Ukuran ikon dikurangi (dari 26)
                  ),
                  onPressed: () => _navigateToEdit(context, rumah),
                  tooltip: 'Edit Data Rumah',
                  padding: EdgeInsets.zero, // Menghilangkan padding default
                  constraints:
                      const BoxConstraints(), // Menghilangkan batasan ukuran min
                ),
                const SizedBox(width: 6), // Jarak dipertahankan
                // Icon Hapus
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                    size: 24, // Ukuran ikon dikurangi (dari 26)
                  ),
                  onPressed: () => _onDeleteRumah(rumah),
                  tooltip: 'Hapus Data Rumah',
                  padding: EdgeInsets.zero, // Menghilangkan padding default
                  constraints:
                      const BoxConstraints(), // Menghilangkan batasan ukuran min
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}