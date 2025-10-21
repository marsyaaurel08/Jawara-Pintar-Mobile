import 'package:flutter/material.dart';
import '../pages/tambah_warga_page.dart';
import '../pages/edit_warga_page.dart';
import '../pages/detail_warga_page.dart';

class WargaListPage extends StatefulWidget {
  const WargaListPage({Key? key}) : super(key: key);

  @override
  _WargaListPageState createState() => _WargaListPageState();
}

class _WargaListPageState extends State<WargaListPage> {
  // Warna kustom Deep Purple untuk konsistensi
  static const Color _primaryColor = Color(0xFF2E6BFF);
  static const Color _accentColor = Color(
    0xFF00C853,
  ); // Hijau untuk status Aktif/Hidup
  static const Color _warningColor = Color(
    0xFFFF9800,
  ); // Orange untuk Nonaktif/Istri/Anak

  // --- Data Warga DILENGKAPI dengan detail Tambahan ---
  final List<Map<String, dynamic>> _allWargaList = [
    {
      "nama": "Farhan Aditia",
      "nik": "4567890864654356",
      "keluarga": "Keluarga Farhan",
      "jenisKelamin": "Laki-laki",
      "tempatLahir": "Jakarta",
      "tanggalLahir": "1995-03-10",
      "agama": "Islam",
      "golonganDarah": "A",
      "telepon": "081234567890",
      "pendidikan": "S1",
      "pekerjaan": "Swasta",
      "peranKeluarga": "Kepala Keluarga",
      "domisili": "Aktif",
      "status": "Hidup",
    },
    {
      "nama": "Rendha Putra Rahmadya",
      "nik": "3505111512040002",
      "keluarga": "Keluarga Rendha Putra Rahmadya",
      "jenisKelamin": "Laki-laki",
      "tempatLahir": "Blitar",
      "tanggalLahir": "2004-12-15",
      "agama": "Kristen",
      "golonganDarah": "O",
      "telepon": "085798765432",
      "pendidikan": "SMA/SMK",
      "pekerjaan": "Pelajar/Mahasiswa",
      "peranKeluarga": "Anak",
      "domisili": "Aktif",
      "status": "Hidup",
    },
    {
      "nama": "Anti Micin",
      "nik": "1234567890987654",
      "keluarga": "Keluarga Anti Micin Yang Super Duper Panjang Banget Sampai Tiga Baris", // Data sengaja dibuat panjang
      "jenisKelamin": "Laki-laki",
      "tempatLahir": "Surabaya",
      "tanggalLahir": "1970-07-25",
      "agama": "Hindu",
      "golonganDarah": "B",
      "telepon": "081122334455",
      "pendidikan": "S3",
      "pekerjaan": "PNS",
      "peranKeluarga": "Kepala Keluarga",
      "domisili": "Nonaktif",
      "status": "Hidup",
    },
    {
      "nama": "Citra Lestari",
      "nik": "3505111512040003",
      "keluarga": "Keluarga Citra Lestari",
      "jenisKelamin": "Perempuan",
      "tempatLahir": "Bandung",
      "tanggalLahir": "1960-01-01",
      "agama": "Katolik",
      "golonganDarah": "AB",
      "telepon": "089600011122",
      "pendidikan": "SD",
      "pekerjaan": "Lainnya",
      "peranKeluarga": "Istri",
      "domisili": "Nonaktif",
      "status": "Meninggal", // Example of 'Meninggal' status
    },
  ];

  // --- State Variables for Search and Filter ---
  String _searchQuery = '';
  String? _selectedJenisKelamin;
  String? _selectedStatus; // This is the filter for 'status'
  String? _selectedKeluarga;

  // --- Filter Options (for the Dialog) ---
  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _statusOptions = [
    'Hidup',
    'Meninggal',
  ]; // Options for status filter
  List<String> get _keluargaOptions => _allWargaList
      .map((warga) => warga['keluarga'] as String)
      .toSet()
      .toList();

  // --- Computed List for Display (with search and all filters) ---
  List<Map<String, dynamic>> get _filteredWargaList {
    return _allWargaList.where((warga) {
      final matchesSearch =
          warga['nama'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          warga['nik'].contains(_searchQuery);

      final matchesJenisKelamin =
          _selectedJenisKelamin == null ||
          warga['jenisKelamin'] == _selectedJenisKelamin;
      final matchesStatus =
          _selectedStatus == null || warga['status'] == _selectedStatus;
      final matchesKeluarga =
          _selectedKeluarga == null || warga['keluarga'] == _selectedKeluarga;

      return matchesSearch &&
          matchesJenisKelamin &&
          matchesStatus &&
          matchesKeluarga;
    }).toList();
  }

  // --------------------------------------------------------------------------
  // --- FUNCTION: Navigate to Detail Page (Updated to use DetailWargaPage) ---
  // --------------------------------------------------------------------------
  void _showDetailWarga(BuildContext context, Map<String, dynamic> wargaData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailWargaPage(wargaData: wargaData),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // --- FUNCTION: Navigate to Edit Page ---
  // --------------------------------------------------------------------------
  void _navigateToEditPage(BuildContext context, Map<String, dynamic> warga) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditWargaPage(wargaData: warga)),
    );
  }

  // --------------------------------------------------------------------------
  // --- FUNCTION: Show Filter Dialog & Helper (TIDAK BERUBAH) ---
  // --------------------------------------------------------------------------
  void _showFilterDialog(BuildContext context) {
    String? tempJenisKelamin = _selectedJenisKelamin;
    String? tempStatus = _selectedStatus;
    String? tempKeluarga = _selectedKeluarga;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Filter Data Warga',
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildFilterDropdown(
                      setDialogState,
                      'Jenis Kelamin',
                      tempJenisKelamin,
                      _jenisKelaminOptions,
                      (newValue) => tempJenisKelamin = newValue,
                    ),
                    const SizedBox(height: 12),
                    _buildFilterDropdown(
                      setDialogState,
                      'Status Kehidupan',
                      tempStatus,
                      _statusOptions,
                      (newValue) => tempStatus = newValue,
                    ),
                    const SizedBox(height: 12),
                    _buildFilterDropdown(
                      setDialogState,
                      'Keluarga',
                      tempKeluarga,
                      _keluargaOptions,
                      (newValue) => tempKeluarga = newValue,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      tempJenisKelamin = null;
                      tempStatus = null;
                      tempKeluarga = null;
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedJenisKelamin = tempJenisKelamin;
                      _selectedStatus = tempStatus;
                      _selectedKeluarga = tempKeluarga;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'TERAPKAN FILTER',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFilterDropdown(
    StateSetter setDialogState,
    String label,
    String? currentValue,
    List<String> items,
    Function(String?) onValueChange,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _primaryColor, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: _primaryColor, width: 2.0),
        ),
      ),
      value: currentValue,
      hint: Text('-- Pilih $label --', style: const TextStyle(fontSize: 14)),
      isExpanded: true,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
      onChanged: (String? newValue) {
        setDialogState(() {
          onValueChange(newValue);
        });
      },
    );
  }
  // --------------------------------------------------------------------------

  // --- Widget pembantu untuk Badge Status ---
  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
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

  // --- FUNCTION: Hapus Data Warga dengan Konfirmasi ---
  void _onDeleteRumah(Map<String, dynamic> warga) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Yakin ingin menghapus data "${warga['nama']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _allWargaList.remove(warga);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFilterActive =
        _selectedJenisKelamin != null ||
        _selectedStatus != null ||
        _selectedKeluarga != null;

    return Scaffold(
      body: Column(
        children: [
          // Search Bar and Filter Button
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
                      hintText: 'Cari nama atau NIK...',
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

          // Filter Reset Chip
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
                    'Hapus Filter',
                    style: TextStyle(color: _primaryColor, fontSize: 13),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedJenisKelamin = null;
                      _selectedStatus = null;
                      _selectedKeluarga = null;
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

          // Warga List (NEW EPIC CARD DESIGN)
          Expanded(
            child: _filteredWargaList.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Tidak ada data warga yang cocok dengan kriteria.',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredWargaList.length,
                    itemBuilder: (context, index) {
                      final warga = _filteredWargaList[index];
                      final statusIsHidup = warga['status'] == 'Hidup';
                      final domisiliIsAktif = warga['domisili'] == 'Aktif';

                      final statusColor = statusIsHidup
                          ? _accentColor
                          : Colors.red.shade700;
                      final domisiliColor = domisiliIsAktif
                          ? Colors.blue.shade700
                          : _warningColor;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () => _showDetailWarga(context, warga),
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ListTile(
                              // --- LEADING: Ikon Profil/Avatar Generik ---
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: _primaryColor.withOpacity(0.1),
                                child: const Icon(
                                  Icons.person_pin,
                                  color: _primaryColor,
                                  size: 32,
                                ),
                              ),

                              // --- TITLE: Nama Lengkap (Sudah dibatasi) ---
                              title: Text(
                                warga['nama'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),

                              // --- SUBTITLE: Detail Info Bawah ---
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  // NIK & Keluarga
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.credit_card,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      // 💥 PERBAIKAN PENTING DI SINI: Wrap NIK dengan Expanded
                                      Expanded(
                                        child: Text(
                                          "NIK: ${warga['nik']}",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis, // Mencegah overflow NIK
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  // Keluarga & Peran (Sudah dibatasi)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.groups,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          "${warga['keluarga']} (${warga['peranKeluarga']})",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis, // Mencegah overflow Nama Keluarga
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Status Badges
                                  Row(
                                    children: [
                                      _buildStatusBadge(
                                        warga['domisili'],
                                        domisiliColor,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildStatusBadge(
                                        warga['status'],
                                        statusColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // --- TRAILING: Tombol Aksi (Edit & Hapus) ---
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icon Edit
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_note_rounded,
                                      color: _primaryColor,
                                      size: 26,
                                    ),
                                    onPressed: () =>
                                        _navigateToEditPage(context, warga),
                                    tooltip: 'Edit Data Warga',
                                  ),
                                  // Icon Hapus
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.red,
                                      size: 26,
                                    ),
                                    onPressed: () => _onDeleteRumah(warga),
                                    tooltip: 'Hapus Data Rumah',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahWargaPage()),
          );
        },
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Warga',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}