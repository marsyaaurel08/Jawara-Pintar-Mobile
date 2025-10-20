import 'package:flutter/material.dart';

// Definisi Warna Kustom yang Ditingkatkan (Dipertahankan dari file TambahRumahPage)
const Color _primaryColor = Color(0xFF2E6BFF);
const Color _primaryLightColor = Color.fromARGB(255, 196, 211, 247);
const Color _backgroundColor = Color(0xFFF5F7FA); // Background soft light
const Color _textColor = Color(0xFF37474F); // Abu-abu gelap (Deep Grey)
const Color _shadowColor = Color(0xFFDCE1E7); // Warna bayangan ringan

// --- Data Model Dummy untuk Contoh (Opsional: Hapus jika Anda sudah punya model) ---
class RumahData {
  final String alamatRumah;
  final String rt;
  final String rw;
  final String keluarga;
  final String statusKepemilikan;
  final String statusRumah;

  RumahData({
    required this.alamatRumah,
    required this.rt,
    required this.rw,
    required this.keluarga,
    required this.statusKepemilikan,
    required this.statusRumah,
  });
}
// ---------------------------------------------------------------------------------


class EditRumahPage extends StatefulWidget {
  // 1. Tambahkan data awal (RumahData) yang akan diedit di Constructor
  final RumahData rumahToEdit;

  const EditRumahPage({
    super.key,
    required this.rumahToEdit,
  });

  @override
  State<EditRumahPage> createState() => _EditRumahPageState();
}

class _EditRumahPageState extends State<EditRumahPage> {
  final _formKey = GlobalKey<FormState>();

  // --- State Variables untuk Data Rumah ---
  // 2. Inisialisasi state dengan data yang dibawa dari constructor (widget.rumahToEdit)
  late String? _selectedKeluarga;
  late String _alamatRumah;
  late String? _selectedRT;
  late String? _selectedRW;
  late String? _selectedStatusKepemilikan;
  late String? _selectedStatusRumah;

  // --- List Opsi (Sama) ---
  final List<String> _listKeluarga = ['Keluarga Farhan', 'Keluarga Rendha', 'Keluarga Anti Micin', 'Keluarga Lainnya'];
  final List<String> _listRT = ['001', '002', '003', '004', '005'];
  final List<String> _listRW = ['01', '02', '03'];
  final List<String> _listStatusKepemilikan = ['Pemilik', 'Penyewa', 'Pinjam Pakai'];
  final List<String> _listStatusRumah = ['Aktif', 'Nonaktif', 'Kosong'];

  // --- Ukuran Font & Spasi yang Disesuaikan untuk Mobile (Sama) ---
  static const double _fontSizeDefault = 14.0;
  static const double _fontSizeTitle = 16.0;
  static const double _paddingVertical = 14.0;
  static const double _paddingHorizontal = 16.0;
  static const double _spacingDefault = 16.0;
  static const double _buttonHeight = 48.0;
  static const double _appBarFontSize = 18.0;

  @override
  void initState() {
    super.initState();
    // 3. Inisialisasi state dari data yang akan diedit
    _selectedKeluarga = widget.rumahToEdit.keluarga;
    _alamatRumah = widget.rumahToEdit.alamatRumah;
    _selectedRT = widget.rumahToEdit.rt;
    _selectedRW = widget.rumahToEdit.rw;
    _selectedStatusKepemilikan = widget.rumahToEdit.statusKepemilikan;
    _selectedStatusRumah = widget.rumahToEdit.statusRumah;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Logika update data ke database/API akan berada di sini.
      
      // Tampilkan SnackBar Konfirmasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perubahan data rumah ${_alamatRumah.length > 15 ? _alamatRumah.substring(0, 15) + '...' : _alamatRumah} berhasil disimpan! ✅'),
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      // Optional: Navigator.pop(context);
    }
  }

  void _resetForm() {
    // Dialog konfirmasi untuk reset
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Perubahan?', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        // 4. Ubah pesan reset agar sesuai dengan konteks edit
        content: const Text('Anda yakin ingin mengembalikan semua input ke nilai awal sebelum diedit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('BATAL', style: TextStyle(color: _textColor)),
          ),
          ElevatedButton(
            onPressed: () {
              // Reset ke nilai awal (widget.rumahToEdit)
              _formKey.currentState!.reset();
              setState(() {
                _selectedKeluarga = widget.rumahToEdit.keluarga;
                _alamatRumah = widget.rumahToEdit.alamatRumah;
                _selectedRT = widget.rumahToEdit.rt;
                _selectedRW = widget.rumahToEdit.rw;
                _selectedStatusKepemilikan = widget.rumahToEdit.statusKepemilikan;
                _selectedStatusRumah = widget.rumahToEdit.statusRumah;
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('KEMBALIKAN'),
          ),
        ],
      ),
    );
  }

  // --- Helper Function untuk Judul Sub-section (Sama) ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 5,
            height: _fontSizeTitle + 5,
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: _fontSizeTitle,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- Field Helper Functions (Disesuaikan untuk Edit) ---
  Widget _buildTextField(
      String label,
      String hint,
      Function(String) onSaved, {
      TextInputType keyboardType = TextInputType.text,
      String? initialValue, // initialValue digunakan untuk mengisi data awal
      int? maxLines = 1,
      IconData? prefixIcon,
  }) {
    return TextFormField(
      initialValue: initialValue, // Menggunakan initialValue
      maxLines: maxLines,
      style: const TextStyle(fontSize: _fontSizeDefault, color: _textColor),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _primaryColor, size: 20) : null,
        labelStyle: TextStyle(fontSize: _fontSizeDefault, color: Colors.grey.shade700),
        hintStyle: TextStyle(fontSize: _fontSizeDefault, color: Colors.grey.shade500),
        
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: _paddingHorizontal, vertical: maxLines! > 1 ? 16.0 : _paddingVertical),
      ),
      keyboardType: keyboardType,
      onSaved: (value) => onSaved(value ?? ''),
      validator: (value) => (value == null || value.isEmpty) ? 'Kolom $label tidak boleh kosong' : null,
    );
  }

  Widget _buildDropdown(
      String label,
      String? value,
      List<String> items,
      Function(String?) onChanged, {
      IconData? prefixIcon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: _fontSizeDefault, color: _textColor)),
                    ))
          .toList(),
      onChanged: onChanged,
      style: const TextStyle(color: _textColor, fontSize: _fontSizeDefault),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Pilih $label',
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _primaryColor, size: 20) : null,
        labelStyle: TextStyle(fontSize: _fontSizeDefault, color: Colors.grey.shade700),
        hintStyle: TextStyle(fontSize: _fontSizeDefault, color: Colors.grey.shade500),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: _paddingHorizontal, vertical: _paddingVertical),
      ),
      validator: (value) => value == null ? 'Pilih $label' : null,
      isExpanded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        // 5. Ubah judul AppBar & set warna ikon (panah kembali) menjadi putih
        title: const Text(
          'Edit Data Rumah', 
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: _appBarFontSize)
        ),
        // **Mengatur warna ikon di AppBar menjadi putih**
        iconTheme: const IconThemeData(color: Colors.white), 
        backgroundColor: _primaryColor,
        centerTitle: true,
        elevation: 4,
        // **Tidak perlu menambahkan leading/actions untuk menghapus ikon rumah karena tidak ada ikon rumah di AppBar aslinya.**
        // Jika ada, biasanya kita akan menggantinya dengan widget lain atau menghilangkan widget IconButton.
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Bagian Detail Alamat ---
                        _buildSectionTitle('Informasi Geografis'),
                        
                        // Alamat Rumah (Multiline)
                        _buildTextField(
                          'Alamat Rumah', 
                          'Masukkan alamat lengkap (Blok A1/No 01)', 
                          (val) => _alamatRumah = val,
                          initialValue: _alamatRumah, // Mengisi nilai awal
                          prefixIcon: Icons.location_on_outlined, maxLines: 3
                        ),
                        const SizedBox(height: _spacingDefault),
                        
                        // RT/RW (Side-by-side)
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                'RT', _selectedRT, _listRT, (val) => setState(() => _selectedRT = val),
                                prefixIcon: Icons.format_list_numbered_rtl,
                              ),
                            ),
                            const SizedBox(width: _spacingDefault),
                            Expanded(
                              child: _buildDropdown(
                                'RW', _selectedRW, _listRW, (val) => setState(() => _selectedRW = val),
                                prefixIcon: Icons.format_list_numbered,
                              ),
                            ),
                          ],
                        ),

                        // --- Bagian Detail Kepemilikan & Status ---
                        _buildSectionTitle('Detail Kepemilikan & Penghuni'),

                        // Pilih Keluarga
                        _buildDropdown('Keluarga Penghuni', _selectedKeluarga, _listKeluarga,
                            (val) => setState(() => _selectedKeluarga = val),
                            prefixIcon: Icons.family_restroom_outlined),
                        const SizedBox(height: _spacingDefault),

                        // Status Kepemilikan
                        _buildDropdown('Status Kepemilikan', _selectedStatusKepemilikan, _listStatusKepemilikan,
                            (val) => setState(() => _selectedStatusKepemilikan = val),
                            prefixIcon: Icons.home_work_outlined),
                        const SizedBox(height: _spacingDefault),
                        
                        // Status Rumah
                        _buildDropdown('Status Rumah', _selectedStatusRumah, _listStatusRumah,
                            (val) => setState(() => _selectedStatusRumah = val),
                            prefixIcon: Icons.check_circle_outline),
                        
                        const Spacer(),
                        const SizedBox(height: 32),

                        // --- Tombol Aksi (Full Width) ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 6. Ubah teks tombol SIMPAN menjadi UPDATE
                            ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.save_outlined),
                              label: const Text(
                                'SIMPAN PERUBAHAN',
                                style: TextStyle(fontSize: _fontSizeDefault, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, _buttonHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // 7. Ubah teks tombol RESET menjadi KEMBALIKAN/RESET
                            OutlinedButton.icon(
                              onPressed: _resetForm,
                              icon: const Icon(Icons.refresh_outlined),
                              label: const Text(
                                'RESET',
                                style: TextStyle(fontSize: _fontSizeDefault, fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _primaryColor,
                                minimumSize: const Size(double.infinity, _buttonHeight),
                                side: const BorderSide(color: _primaryColor, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}