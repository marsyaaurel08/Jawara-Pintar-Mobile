import 'package:flutter/material.dart';

// Definisi Warna Kustom (Konsisten)
const Color _primaryColor = Color(0xFF2E6BFF); // Biru Tua (Deep Blue)
const Color _backgroundColor = Color(0xFFF5F7FA); // Background soft light
const Color _textColor = Color(0xFF37474F); // Abu-abu gelap (Deep Grey)
const Color _fieldColor = Colors.white; // Warna isian field sesuai gambar

class TambahKeluargaPage extends StatefulWidget {
  const TambahKeluargaPage({Key? key}) : super(key: key);

  @override
  State<TambahKeluargaPage> createState() => _TambahKeluargaPageState();
}

class _TambahKeluargaPageState extends State<TambahKeluargaPage> {
  final _formKey = GlobalKey<FormState>();

  // --- State Variabel ---
  String _namaKeluarga = '';
  String _kepalaKeluarga = '';
  String _alamatRumah = '';
  String? _statusKepemilikan; // Dropdown
  String _status = 'Aktif'; // Default 'Aktif'

  // Opsi Dropdown untuk Status Kepemilikan
  final List<String> _kepemilikanOptions = ['Pemilik', 'Penyewa', 'Lainnya'];

  // --- FUNGSI SUBMIT ---
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Data yang siap dikirim/disimpan (simulasi)
      final newKeluargaData = {
        'namaKeluarga': _namaKeluarga,
        'kepalaKeluarga': _kepalaKeluarga,
        'alamatRumah': _alamatRumah,
        'statusKepemilikan': _statusKepemilikan,
        'status': _status, 
      };

      // Tampilkan SnackBar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Keluarga "${_namaKeluarga}" berhasil ditambahkan!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Kembali ke halaman sebelumnya (KeluargaListPage)
      Navigator.pop(context, newKeluargaData);
    }
  }

  // --- FUNGSI RESET FORM ---
  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _statusKepemilikan = null;
      _status = 'Aktif'; // Reset status ke default
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulir direset.'),
          duration: Duration(seconds: 1),
        ),
      );
  }

  // --------------------------------------------------------------------------
  // --- WIDGET PEMBANTU (Disesuaikan untuk Mobile) ---
  // --------------------------------------------------------------------------

  // Custom Card Field Widget (MENGEMAS INPUT FIELD DENGAN STYLE CARD)
  Widget _buildCardField({
    required Widget child,
    required IconData icon,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // Padding lebih kecil
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _fieldColor, // Warna Putih
        borderRadius: BorderRadius.circular(10), // Border radius sedikit lebih kecil
        border: Border.all(color: Colors.grey.shade300, width: 1), // Border tipis
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: padding, // Menggunakan padding yang dapat di-override
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: _primaryColor, size: 22), // Ukuran icon sedikit lebih kecil
          const SizedBox(width: 10), // Spasi lebih kecil
          Expanded(child: child),
        ],
      ),
    );
  }

  // Wrapper untuk TextFormField agar menggunakan Card Style
  Widget _buildCardTextField({
    required String label,
    required IconData icon,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return _buildCardField(
      icon: icon,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: _textColor.withOpacity(0.7), fontSize: 14), // Font lebih kecil
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0), // Padding vertikal lebih kecil
        ),
        maxLines: maxLines,
        onSaved: onSaved,
        validator: validator,
        cursorColor: _primaryColor,
        style: const TextStyle(color: _textColor, fontSize: 14), // Font lebih kecil
      ),
    );
  }

  // Wrapper untuk DropdownButtonFormField agar menggunakan Card Style
  Widget _buildCardDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return _buildCardField(
      icon: icon,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: _textColor.withOpacity(0.7), fontSize: 14), // Font lebih kecil
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0), // Padding vertikal lebih kecil
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(color: _textColor, fontSize: 14)), // Font lebih kecil
          );
        }).toList(),
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black87),
        icon: const Icon(Icons.keyboard_arrow_down, color: _primaryColor, size: 22), // Ukuran icon lebih kecil
      ),
    );
  }

  // Header Section
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Padding lebih kecil
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: _primaryColor, width: 4)),
        ),
        padding: const EdgeInsets.only(left: 10), // Padding lebih kecil
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16, // Font lebih kecil
            fontWeight: FontWeight.bold, 
            color: _textColor,
          ),
        ),
      ),
    );
  }

  // Segmented Button untuk Status Keluarga
  Widget _buildStatusSegmentedButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 6.0), // Padding lebih kecil
          child: Text(
            'Status Keluarga:',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: _textColor), // Font lebih kecil
          ),
        ),
        SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: 'Aktif',
              label: Text('Aktif'),
              icon: Icon(Icons.check_circle_outline, size: 16), // Icon lebih kecil
            ),
            ButtonSegment<String>(
              value: 'Nonaktif',
              label: Text('Nonaktif'),
              icon: Icon(Icons.cancel_outlined, size: 16), // Icon lebih kecil
            ),
          ],
          selected: <String>{_status},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              _status = newSelection.first;
            });
          },
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: _primaryColor,
            selectedForegroundColor: Colors.white,
            foregroundColor: _textColor,
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Padding lebih kecil
            textStyle: const TextStyle(fontSize: 14), // Font lebih kecil
          ),
          emptySelectionAllowed: false,
          showSelectedIcon: false,
          multiSelectionEnabled: false,
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // --- WIDGET UTAMA: BUILD ---
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor, 
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0, 
        centerTitle: true, // Judul di tengah
        title: const Text(
          'Tambah Data Keluarga',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Font lebih kecil
        ),
      ),
      body: Column(
        children: [
          // Tidak perlu SizedBox(height: 16) lagi karena tidak ada rounded corner
          
          Expanded(
            child: Container(
              // Background bawah menggunakan warna soft light
              decoration: BoxDecoration(
                color: _backgroundColor,
                // borderRadius: const BorderRadius.only( // Dihilangkan
                //   topLeft: Radius.circular(25),
                //   topRight: Radius.circular(25),
                // ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // Shadow lebih lembut
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0), // Padding lebih kecil
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // === BAGIAN 1: INFORMASI KELUARGA & ALAMAT ===
                      _buildSectionHeader('Informasi Keluarga & Alamat'),
                      const SizedBox(height: 14), // Spasi lebih kecil
                      
                      // 1. Nama Keluarga
                      _buildCardTextField(
                        label: 'Nama Keluarga',
                        icon: Icons.groups,
                        onSaved: (value) => _namaKeluarga = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Nama keluarga wajib diisi' : null,
                      ),
                      const SizedBox(height: 16), // Spasi lebih kecil

                      // 2. Nama Kepala Keluarga
                      _buildCardTextField(
                        label: 'Nama Kepala Keluarga',
                        icon: Icons.person,
                        onSaved: (value) => _kepalaKeluarga = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Nama kepala keluarga wajib diisi' : null,
                      ),
                      const SizedBox(height: 16), // Spasi lebih kecil

                      // 3. Alamat Rumah
                      _buildCardTextField(
                        label: 'Alamat Rumah',
                        icon: Icons.location_on,
                        maxLines: 2,
                        onSaved: (value) => _alamatRumah = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Alamat rumah wajib diisi' : null,
                      ),
                      const SizedBox(height: 24), // Spasi lebih kecil

                      // === BAGIAN 2: DETAIL KEPEMILIKAN & STATUS ===
                      _buildSectionHeader('Detail Kepemilikan & Status'),
                      const SizedBox(height: 14), // Spasi lebih kecil

                      // 4. Status Kepemilikan (Dropdown dengan Card Style)
                      _buildCardDropdownField(
                        label: 'Pilih Status Kepemilikan',
                        icon: Icons.home_work,
                        value: _statusKepemilikan,
                        items: _kepemilikanOptions,
                        onChanged: (String? newValue) {
                          setState(() {
                            _statusKepemilikan = newValue;
                          });
                        },
                        onSaved: (value) => _statusKepemilikan = value,
                        validator: (value) => value == null
                            ? 'Status kepemilikan wajib dipilih'
                            : null,
                      ),
                      const SizedBox(height: 16), // Spasi lebih kecil

                      // 5. Status Keluarga (Segmented Button)
                      _buildStatusSegmentedButton(),
                      const SizedBox(height: 24), // Spasi lebih kecil

                      // Tombol Simpan dan Reset (Bersebelahan)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.save, size: 18), // Icon lebih kecil
                              label: const Text('SIMPAN'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14), // Padding lebih kecil
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Border radius lebih kecil
                                ),
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold), // Font lebih kecil
                              ),
                            ),
                          ),
                          const SizedBox(width: 12), // Spasi antara tombol
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _resetForm,
                              icon: const Icon(Icons.refresh, size: 18), // Icon lebih kecil
                              label: const Text('RESET'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 14), // Padding lebih kecil
                                side: const BorderSide(color: _primaryColor, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Border radius lebih kecil
                                ),
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold), // Font lebih kecil
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24), 
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}