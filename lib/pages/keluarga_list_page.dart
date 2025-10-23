import 'package:flutter/material.dart';
import '../pages/tambah_keluarga_page.dart'; 
// Asumsi halaman detail dan edit juga sudah disesuaikan untuk menerima Map<String, dynamic>
import '../pages/detail_keluarga_page.dart'; 

// Definisi Warna Kustom (Konsisten)
const Color _primaryColor = Color(0xFF2E6BFF); // Biru Tua (Deep Blue)
const Color _secondaryColor = Color(0xFF00C853); // Hijau untuk Aksen/Aktif
const Color _backgroundColor = Color(0xFFF5F7FA); // Background soft light
const Color _textColor = Color(0xFF37474F); // Abu-abu gelap (Deep Grey)
const Color _nonAktifColor = Colors.red; // Merah untuk Nonaktif

// --- Data Dummy Keluarga (Menggunakan Map<String, dynamic>) ---
// CATATAN: Dibuat final di luar class State agar menjadi sumber data awal.
// Di dalam State, kita akan menggunakan salinannya agar bisa di-update.
final List<Map<String, dynamic>> _initialKeluargaList = [
  {
    "no": 1,
    "namaKeluarga": "Keluarga Farhan",
    "kepalaKeluarga": "Farhan Kurniawan",
    "alamatRumah": "Jl. Merbabu No. 12A, RT 001/RW 01",
    "statusKepemilikan": "Pemilik",
    "status": "Aktif",
  },
  {
    "no": 2,
    "namaKeluarga": "Keluarga Rendra",
    "kepalaKeluarga": "Rendra Setyawan",
    "alamatRumah": "Komplek Melati Blok C5, RT 003/RW 02",
    "statusKepemilikan": "Penyewa",
    "status": "Aktif",
  },
  {
    "no": 3,
    "namaKeluarga": "Keluarga Anti Micin",
    "kepalaKeluarga": "Budi Setiawan",
    "alamatRumah": "Perumahan Indah No. 44, RT 005/RW 03",
    "statusKepemilikan": "Lainnya",
    "status": "Nonaktif",
  },
];
// -------------------------------------------------------------

class KeluargaListPage extends StatefulWidget {
  const KeluargaListPage({Key? key}) : super(key: key);

  @override
  State<KeluargaListPage> createState() => _KeluargaListPageState();
}

class _KeluargaListPageState extends State<KeluargaListPage> {
  String _searchQuery = '';
  bool isFilterActive = false;
  String? _selectedStatusFilter;
  
  // List yang akan dimanipulasi (filter, edit, hapus)
  List<Map<String, dynamic>> _currentKeluargaList = []; 

  // Ukuran Font Default untuk Mobile
  static const double _fontSizeSubtitle = 12.0;
  static const double _fontSizeBadge = 10.0;
  static const double _fabBottomPadding = 80.0; 

  @override
  void initState() {
    super.initState();
    // Salin data dummy ke state saat initState
    _currentKeluargaList = List.from(_initialKeluargaList);
  }

  // --- LOGIC FILTERING (Menggunakan Map<String, dynamic>) ---
  // Ganti getter lama yang menggunakan KeluargaData
  List<Map<String, dynamic>> get _filteredKeluargaList {
    return _currentKeluargaList.where((keluarga) {
      final query = _searchQuery.toLowerCase();
      
      // Ambil data dari Map. Gunakan `?? ''` untuk menghindari error jika key tidak ada.
      final namaKeluarga = keluarga['namaKeluarga']?.toString().toLowerCase() ?? '';
      final kepalaKeluarga = keluarga['kepalaKeluarga']?.toString().toLowerCase() ?? '';
      final alamatRumah = keluarga['alamatRumah']?.toString().toLowerCase() ?? '';
      final status = keluarga['status']?.toString() ?? '';

      final matchesSearch = namaKeluarga.contains(query) ||
          kepalaKeluarga.contains(query) ||
          alamatRumah.contains(query);

      final matchesFilter = _selectedStatusFilter == null
          ? true
          : status == _selectedStatusFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _resetFilter() {
    setState(() {
      isFilterActive = false;
      _selectedStatusFilter = null;
    });
  }

  // --- WIDGET HELPER ---

  // Widget untuk Badge Status
  Widget _buildStatusBadge(String status) {
    Color color = status == 'Aktif' ? _secondaryColor : _nonAktifColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15), 
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: _fontSizeBadge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(80),
      //   child: AppBar(
      //     backgroundColor: const Color.fromARGB(255, 5, 117, 209),
      //     elevation: 0,
      //     automaticallyImplyLeading: false,
      //     flexibleSpace: Container(
      //       decoration: const BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: [
      //             Color.fromARGB(255, 5, 117, 209),
      //             Color.fromARGB(255, 3, 95, 170),
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
      //                   IconButton(
      //                     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //                     onPressed: () => Navigator.pop(context),
      //                   ),
      //                   const SizedBox(width: 4),
      //                   Container(
      //                     padding: const EdgeInsets.all(8),
      //                     decoration: BoxDecoration(
      //                       color: Colors.white.withOpacity(0.2),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     child: const Icon(
      //                       Icons.family_restroom_outlined,
      //                       color: Colors.white,
      //                       size: 24,
      //                     ),
      //                   ),
      //                   const SizedBox(width: 12),
      //                   const Text(
      //                     'Daftar Keluarga',
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
          // Search Bar and Filter Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(fontSize: 14.0),
                      decoration: InputDecoration(
                        hintText: 'Cari nama keluarga...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade50),
                        prefixIcon:
                            const Icon(Icons.search, color: _primaryColor, size: 20),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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

          // Filter Reset Chip
          if (isFilterActive)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ActionChip(
                  avatar: const Icon(Icons.close, color: Colors.white, size: 16),
                  label: Text(
                      'Filter Aktif: ${_selectedStatusFilter}',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  onPressed: _resetFilter,
                  backgroundColor: _primaryColor,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
              ),
            ),

          // Keluarga List
          Expanded(
            child: _filteredKeluargaList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_dissatisfied_outlined,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        const Text(
                          'Tidak ada data keluarga yang cocok.',
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0, bottom: _fabBottomPadding), 
                    itemCount: _filteredKeluargaList.length,
                    itemBuilder: (context, index) {
                      // Ambil Map untuk item saat ini
                      final keluarga = _filteredKeluargaList[index];
                      return _buildKeluargaCard(keluarga, context);
                    },
                  ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke TambahKeluargaPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahKeluargaPage()),
          );
        },
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Keluarga',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // --- FUNCTION: Show Filter Dialog ---
  void _showFilterDialog(BuildContext context) {
    String? tempStatus = _selectedStatusFilter;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              title: const Text('Filter Data Keluarga'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String?>(
                    title: const Text('Aktif'),
                    value: 'Aktif',
                    groupValue: tempStatus,
                    onChanged: (String? value) =>
                        setStateSB(() => tempStatus = value),
                    dense: true,
                    activeColor: _primaryColor,
                  ),
                  RadioListTile<String?>(
                    title: const Text('Nonaktif'),
                    value: 'Nonaktif',
                    groupValue: tempStatus,
                    onChanged: (String? value) =>
                        setStateSB(() => tempStatus = value),
                    dense: true,
                    activeColor: _primaryColor,
                  ),
                  RadioListTile<String?>(
                    title: const Text('Semua Status'),
                    value: null,
                    groupValue: tempStatus,
                    onChanged: (String? value) =>
                        setStateSB(() => tempStatus = value),
                    dense: true,
                    activeColor: _primaryColor,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedStatusFilter = tempStatus;
                      isFilterActive = tempStatus != null;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor, foregroundColor: Colors.white),
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper widget untuk detail row
  Widget _buildDetailRow(IconData icon, String label, String value,
      {bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isAccent ? _secondaryColor : _textColor),
          const SizedBox(width: 4),
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: _fontSizeSubtitle,
              fontWeight: FontWeight.w600,
              color: _textColor.withOpacity(0.7),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: _fontSizeSubtitle,
                color: isAccent ? _secondaryColor : _textColor,
                fontWeight: isAccent ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Handler untuk aksi edit, detail, dan hapus
  void _handleAction(String action, KeluargaData keluarga, BuildContext context) {
    switch (action) {
      case 'Detail':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailKeluargaPage(keluarga: keluarga),
          ),
        );
        break;
      case 'Edit':
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => EditKeluargaPage(keluargaData: keluarga),
        //   ),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur Edit belum tersedia')),
        );
        break;
      case 'Hapus':
        _showDeleteConfirmation(context, keluarga);
        break;
    }
  }

  // Konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context, KeluargaData keluarga) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus data keluarga "${keluarga.namaKeluarga}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  dummyKeluargaList.remove(keluarga);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Data keluarga "${keluarga.namaKeluarga}" berhasil dihapus')),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // WIDGET: Card untuk setiap item keluarga (Menggunakan KeluargaData)
  Widget _buildKeluargaCard(KeluargaData keluarga, BuildContext context) { // Tipe data diubah
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
      ),
      child: InkWell(
        // Fungsionalitas Detail dipindahkan ke onTap Card
        onTap: () => _handleAction('Detail', keluarga, context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEADING: Ikon Keluarga
              CircleAvatar(
                radius: 28, 
                backgroundColor: _primaryColor.withOpacity(0.15),
                child: const Icon( 
                  Icons.groups_2_outlined, 
                  size: 30,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              
              // CONTENT UTAMA (Title & Subtitle + Status Badge)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title: Nama Keluarga
                    Text(
                      keluarga.namaKeluarga,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.0, 
                          color: _textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Subtitle: Informasi Detail
                    _buildDetailRow(
                        Icons.person_outline, "Kepala", keluarga.kepalaKeluarga),
                    _buildDetailRow(
                        Icons.location_on_outlined, "Alamat", keluarga.alamatRumah),
                    const SizedBox(height: 4),
                    
                    // Status Kepemilikan (Highlight)
                    _buildDetailRow(Icons.account_balance_wallet_outlined,
                        "Kepemilikan", keluarga.statusKepemilikan,
                        isAccent: true),
                    
                    // Badge Status
                    const SizedBox(height: 8),
                    _buildStatusBadge(keluarga.status),
                  ],
                ),
              ),

              // --- TRAILING: Ikon Edit dan Hapus (Pengganti Titik Tiga) ---
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Edit
                  IconButton(
                    icon: const Icon(
                      Icons.edit_note_rounded, // Ikon edit dengan pena
                      color: _primaryColor,
                      size: 26,
                    ),
                    onPressed: () => _handleAction('Edit', keluarga, context),
                    tooltip: 'Edit Data Keluarga',
                  ),
                  // Icon Hapus
                  IconButton(
                    icon: const Icon(
                      Icons.delete_forever_rounded, // Ikon hapus yang tegas
                      color: Colors.red,
                      size: 26,
                    ),
                    onPressed: () => _handleAction('Hapus', keluarga, context),
                    tooltip: 'Hapus Data Keluarga',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}