import 'package:flutter/material.dart';
import '../pages/tambah_warga_page.dart';
import '../pages/edit_warga_page.dart';

class WargaListPage extends StatefulWidget {
  const WargaListPage({Key? key}) : super(key: key);

  @override
  _WargaListPageState createState() => _WargaListPageState();
}

class _WargaListPageState extends State<WargaListPage> {
  // Warna kustom Deep Purple untuk konsistensi
  static const Color _primaryColor = Colors.deepPurple;

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
      "keluarga": "Keluarga Anti Micin",
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

  // --- State Variables for Search and Filter (TIDAK BERUBAH) ---
  String _searchQuery = '';
  String? _selectedJenisKelamin;
  String? _selectedStatus; // This is the filter for 'status'
  String? _selectedKeluarga;

  // --- Filter Options (for the Dialog) (TIDAK BERUBAH) ---
  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _statusOptions = ['Hidup', 'Meninggal']; // Options for status filter
  List<String> get _keluargaOptions =>
      _allWargaList.map((warga) => warga['keluarga'] as String).toSet().toList();

  // --- Computed List for Display (with search and all filters) (TIDAK BERUBAH) ---
  List<Map<String, dynamic>> get _filteredWargaList {
    return _allWargaList.where((warga) {
      final matchesSearch = warga['nama']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          warga['nik'].contains(_searchQuery);

      final matchesJenisKelamin =
          _selectedJenisKelamin == null || warga['jenisKelamin'] == _selectedJenisKelamin;
      final matchesStatus = _selectedStatus == null || warga['status'] == _selectedStatus;
      final matchesKeluarga = _selectedKeluarga == null || warga['keluarga'] == _selectedKeluarga;

      return matchesSearch && matchesJenisKelamin && matchesStatus && matchesKeluarga;
    }).toList();
  }

  // --------------------------------------------------------------------------
  // --- FUNCTION: Show Detail Dialog (TIDAK BERUBAH) ---
  // --------------------------------------------------------------------------
  void _showDetailDialog(BuildContext context, Map<String, dynamic> warga) {
    String formatTanggalLahir(String? tgl) {
      if (tgl == null) return "N/A";
      try {
        final date = DateTime.parse(tgl);
        return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } catch (e) {
        return tgl;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Detail Warga",
            style: const TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDetailRow("Nama", warga['nama']),
                _buildDetailRow("Keluarga", warga['keluarga']),
                const Divider(height: 16),
                _buildDetailRow("NIK", warga['nik']),
                _buildDetailRow("Tempat, Tgl. Lahir",
                    "${warga['tempatLahir'] ?? 'N/A'}, ${formatTanggalLahir(warga['tanggalLahir'])}"),
                _buildDetailRow("Jenis Kelamin", warga['jenisKelamin'] ?? 'N/A'),
                _buildDetailRow("Golongan Darah", warga['golonganDarah'] ?? 'N/A'),
                _buildDetailRow("Agama", warga['agama'] ?? 'N/A'),
                _buildDetailRow("Peran Keluarga", warga['peranKeluarga'] ?? 'N/A'),
                const Divider(height: 16),
                _buildDetailRow("Pendidikan", warga['pendidikan'] ?? 'N/A'),
                _buildDetailRow("Pekerjaan", warga['pekerjaan'] ?? 'N/A'),
                _buildDetailRow("Telepon", warga['telepon'] ?? 'N/A'),
                const Divider(height: 16),
                _buildDetailRow("Status Domisili", warga['domisili'] ?? 'N/A',
                    color: warga['domisili'] == 'Aktif' ? Colors.blue.shade800 : Colors.red.shade800),
                _buildDetailRow("Status Kehidupan", warga['status'] ?? 'N/A',
                    color: warga['status'] == 'Hidup' ? Colors.green.shade800 : Colors.black87),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('TUTUP', style: TextStyle(color: _primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Helper function to build a detailed row in the dialog
  Widget _buildDetailRow(String label, String value,
      {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140, // Lebar label diperlebar
            child: Text("$label:",
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // --- FUNCTION: Navigate to Edit Page (TIDAK BERUBAH) ---
  // --------------------------------------------------------------------------
  void _navigateToEditPage(BuildContext context, Map<String, dynamic> warga) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditWargaPage(wargaData: warga)),
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
              title: const Text('Filter Data Warga', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildFilterDropdown(
                        setDialogState, 'Jenis Kelamin', tempJenisKelamin, _jenisKelaminOptions,
                        (newValue) => tempJenisKelamin = newValue),
                    const SizedBox(height: 16),
                    _buildFilterDropdown(
                        setDialogState, 'Status Kehidupan', tempStatus, _statusOptions,
                        (newValue) => tempStatus = newValue),
                    const SizedBox(height: 16),
                    _buildFilterDropdown(
                        setDialogState, 'Keluarga', tempKeluarga, _keluargaOptions,
                        (newValue) => tempKeluarga = newValue),
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
                  child: const Text('Reset', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedJenisKelamin = tempJenisKelamin;
                      _selectedStatus = tempStatus;
                      _selectedKeluarga = tempKeluarga;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('TERAPKAN FILTER'),
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
      Function(String?) onValueChange) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: _primaryColor, width: 2.0),
        ),
      ),
      value: currentValue,
      hint: Text('-- Pilih $label --'),
      isExpanded: true,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (String? newValue) {
        setDialogState(() {
          onValueChange(newValue);
        });
      },
    );
  }
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool isFilterActive = _selectedJenisKelamin != null ||
        _selectedStatus != null ||
        _selectedKeluarga != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        title: const Text('Data Warga', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search Bar and Filter Button (TIDAK BERUBAH)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau NIK...',
                      prefixIcon: const Icon(Icons.search, color: _primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: _primaryColor.withOpacity(0.05),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: isFilterActive
                        ? _primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: isFilterActive ? Colors.white : Colors.black87,
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
              padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ActionChip(
                  avatar: const Icon(Icons.close, color: _primaryColor, size: 18),
                  label: const Text('Hapus Filter', style: TextStyle(color: _primaryColor)),
                  onPressed: () {
                    setState(() {
                      _selectedJenisKelamin = null;
                      _selectedStatus = null;
                      _selectedKeluarga = null;
                    });
                  },
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  side: const BorderSide(color: _primaryColor),
                ),
              ),
            ),

          // Warga List
          Expanded(
            child: _filteredWargaList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada data warga yang cocok dengan kriteria.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredWargaList.length,
                    itemBuilder: (context, index) {
                      final warga = _filteredWargaList[index];
                      final statusColor = warga['status'] == 'Hidup'
                          ? Colors.green.shade700
                          : Colors.red.shade700;
                      
                      final genderIcon = warga['jenisKelamin'] == 'Laki-laki' 
                          ? Icons.male 
                          : Icons.female;
                      
                      // --- LOGIC BARU UNTUK DOMISILI ---
                      final isDomisiliAktif = warga['domisili'] == 'Aktif';
                      final domisiliColor = isDomisiliAktif 
                          ? Colors.blue.shade700
                          : Colors.orange.shade700;
                      // ---------------------------------

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 4, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        child: InkWell(
                          onTap: () => _showDetailDialog(context, warga), // Show Detail on tap
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Ikon Warga
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: _primaryColor.withOpacity(0.1),
                                  child: Icon(genderIcon, color: _primaryColor, size: 30),
                                ),
                                const SizedBox(width: 15),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 1. Nama (Judul Utama)
                                      Text(
                                        warga['nama'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          color: _primaryColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      // 2. NIK (Sebagai subtitle)
                                      Text(
                                        "NIK: ${warga['nik']}",
                                        style: const TextStyle(color: Colors.black87, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      // 3. Status Domisili (BARU) dan Status Kehidupan
                                      Row(
                                        children: [
                                          // Status Domisili (menggunakan Ikon Rumah)
                                          Icon(Icons.home, size: 16, color: domisiliColor),
                                          const SizedBox(width: 4),
                                          Text(
                                            isDomisiliAktif ? 'Aktif' : 'Nonaktif',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: domisiliColor,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Status Kehidupan
                                          Icon(Icons.circle, size: 8, color: statusColor),
                                          const SizedBox(width: 4),
                                          Text(
                                            warga['status'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: statusColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // 4. Action (Edit Button)
                                IconButton(
                                  icon: const Icon(Icons.edit, color: _primaryColor),
                                  onPressed: () => _navigateToEditPage(context, warga), // Navigate to edit
                                  tooltip: 'Edit Data Warga',
                                ),
                              ],
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
        child: const Icon(Icons.add),
      ),
    );
  }
}