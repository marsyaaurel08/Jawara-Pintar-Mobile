import 'package:flutter/material.dart';
import '../pages/tambah_keluarga_page.dart'; 

// Import file Anda yang sudah ada
import '../pages/detail_keluarga_page.dart'; 
import '../pages/edit_keluarga_page.dart'; 

// CATATAN: Definisi KeluargaData sudah ada di sini, jadi tidak perlu import model terpisah
// jika Anda memutuskan untuk menaruhnya di file ini.

// Definisi Warna Kustom (Konsisten)
const Color _primaryColor = Color(0xFF2E6BFF); // Biru Tua (Deep Blue)
const Color _secondaryColor = Color(0xFF00C853); // Hijau untuk Aksen/Aktif
const Color _backgroundColor = Color(0xFFF5F7FA); // Background soft light
const Color _textColor = Color(0xFF37474F); // Abu-abu gelap (Deep Grey)
const Color _nonAktifColor = Colors.red; // Merah untuk Nonaktif

// Struktur Data Dummy (Tetap menggunakan KeluargaData)
class KeluargaData {
  final int no;
  final String namaKeluarga;
  final String kepalaKeluarga;
  final String alamatRumah;
  final String statusKepemilikan;
  final String status; // Aktif/Nonaktif

  KeluargaData({
    required this.no,
    required this.namaKeluarga,
    required this.kepalaKeluarga,
    required this.alamatRumah,
    required this.statusKepemilikan,
    required this.status,
  });
}

// Menggunakan List yang dapat dimodifikasi (non-final) untuk simulasi hapus
List<KeluargaData> dummyKeluargaList = [
  KeluargaData(no: 1, namaKeluarga: 'Keluarga Farhan', kepalaKeluarga: 'Farhan', alamatRumah: 'Griyashanta L203', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  KeluargaData(no: 2, namaKeluarga: 'Keluarga Rendha Putra Rahmadya', kepalaKeluarga: 'Rendha Putra Rahmadya', alamatRumah: 'Malang', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  KeluargaData(no: 3, namaKeluarga: 'Keluarga Anti Micin', kepalaKeluarga: 'Anti Micin', alamatRumah: 'malang', statusKepemilikan: 'Penyewa', status: 'Aktif'),
  KeluargaData(no: 4, namaKeluarga: 'Keluarga Varezky Naldiba Rimra', kepalaKeluarga: 'Varezky Naldiba Rimra', alamatRumah: 'i', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  KeluargaData(no: 5, namaKeluarga: 'Keluarga Lijat', kepalaKeluarga: 'Lijat', alamatRumah: 'Keluar Wilayah', statusKepemilikan: 'Penyewa', status: 'Nonaktif'),
  KeluargaData(no: 6, namaKeluarga: 'Keluarga Raudhlil Firdaus Naufa', kepalaKeluarga: 'Raudhlil Firdaus Naufa', alamatRumah: 'Bogor Raya Permai F.J 2 no 11', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  KeluargaData(no: 7, namaKeluarga: 'Keluarga Mara Nunez', kepalaKeluarga: 'Mara Nunez', alamatRumah: 'malang', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  KeluargaData(no: 8, namaKeluarga: 'Keluarga Habibie Ed Dien', kepalaKeluarga: 'Habibie Ed Dien', alamatRumah: 'Blok A49', statusKepemilikan: 'Pemilik', status: 'Aktif'),
];

class KeluargaListPage extends StatefulWidget {
  const KeluargaListPage({Key? key}) : super(key: key);

  @override
  State<KeluargaListPage> createState() => _KeluargaListPageState();
}

class _KeluargaListPageState extends State<KeluargaListPage> {
  String _searchQuery = '';
  bool isFilterActive = false;
  String? _selectedStatusFilter;

  // Ukuran Font Default untuk Mobile
  static const double _fontSizeTitle = 15.0;
  static const double _fontSizeSubtitle = 12.0;
  static const double _fontSizeBadge = 10.0;
  static const double _cardPadding = 12.0; 
  static const double _fabBottomPadding = 80.0; 

  // --- LOGIC FILTERING (Menggunakan KeluargaData) ---
  List<KeluargaData> get _filteredKeluargaList {
    return dummyKeluargaList.where((keluarga) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = keluarga.namaKeluarga.toLowerCase().contains(query) ||
          keluarga.kepalaKeluarga.toLowerCase().contains(query) ||
          keluarga.alamatRumah.toLowerCase().contains(query);

      final matchesFilter = _selectedStatusFilter == null
          ? true
          : keluarga.status == _selectedStatusFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _resetFilter() {
    setState(() {
      isFilterActive = false;
      _selectedStatusFilter = null;
    });
  }

  // --- WIDGET HELPER (Tidak Berubah) ---

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

  // Widget untuk Detail Info pada Subtitle
  Widget _buildDetailRow(IconData icon, String label, String text, {Color? color, bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: isAccent ? _primaryColor : Colors.grey.shade500),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isAccent ? _primaryColor : Colors.grey.shade600,
                        fontSize: _fontSizeSubtitle
                    ),
                  ),
                  TextSpan(
                    text: text,
                    style: TextStyle(
                        color: isAccent ? _primaryColor : Colors.grey.shade700,
                        fontSize: _fontSizeSubtitle
                    ),
                  ),
                ]
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Navigasi Aksi (Semua tipe data dan parameter diperbaiki)
  void _handleAction(
    String action,
    KeluargaData keluarga, // Tipe data diubah menjadi KeluargaData
    BuildContext context,
  ) {
    switch (action) {
      case 'Detail':
        // Navigasi ke DetailKeluargaPage. Asumsi DetailKeluargaPage menerima 'keluarga'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailKeluargaPage(keluarga: keluarga),
          ),
        );
        break;
      case 'Edit':
        // Navigasi ke EditKeluargaPage. Menggunakan parameter 'initialData'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditKeluargaPage(initialData: keluarga as dynamic), // cast to dynamic to avoid library-type mismatch
          ),
        );
        break;
      case 'Hapus':
        _showDeleteConfirmation(context, keluarga);
        break;
    }
  }

  // Tampilkan konfirmasi hapus (Menggunakan KeluargaData)
  void _showDeleteConfirmation(BuildContext context, KeluargaData keluarga) { // Tipe data diubah
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
            'Anda yakin ingin menghapus data keluarga "${keluarga.namaKeluarga}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              setState(() {
                // Hapus data dari list dummy
                dummyKeluargaList.removeWhere((k) => k.no == keluarga.no);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Keluarga "${keluarga.namaKeluarga}" dihapus'),
                    backgroundColor: _nonAktifColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: _nonAktifColor, foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Tampilkan dialog filter (Tidak Berubah)
  void _showFilterDialog(BuildContext context) async {
    String? tempStatus = _selectedStatusFilter;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text('Filter Data Keluarga', style: TextStyle(color: _primaryColor)),
          content: StatefulBuilder(
            builder: (context, setStateSB) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status Keluarga:', style: TextStyle(fontWeight: FontWeight.w600)),
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
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor, foregroundColor: Colors.white),
              child: const Text('Terapkan'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {
        _selectedStatusFilter = tempStatus;
        isFilterActive = tempStatus != null;
      });
    }
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
          padding: const EdgeInsets.all(_cardPadding),
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
                          fontSize: _fontSizeTitle + 1, 
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

  // --------------------------------------------------------------------------
  // --- WIDGET UTAMA: BUILD (Tidak Berubah) ---
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,

      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0, 
        title: const Text(
          'Daftar Keluarga',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

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
                      style: const TextStyle(fontSize: 14.0, color: _textColor),
                      decoration: InputDecoration(
                        hintText: 'Cari nama keluarga...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        prefixIcon:
                            const Icon(Icons.search, color: _primaryColor, size: 20),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
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
                    padding: EdgeInsets.only(top: 8.0, bottom: _fabBottomPadding), 
                    itemCount: _filteredKeluargaList.length,
                    itemBuilder: (context, index) {
                      final keluarga = _filteredKeluargaList[index];
                      return _buildKeluargaCard(keluarga, context);
                    },
                  ),
          ),
        ],
      ),

      // Floating Action Button KOTAK (Navigasi ke TambahKeluargaPage)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahKeluargaPage()),
          );
        },
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Keluarga',
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(12.0), 
        ),
      ),
    );
  }
}