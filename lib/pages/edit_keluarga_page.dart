import 'package:flutter/material.dart';

// Definisi Warna Kustom (Konsisten)
const Color _primaryColor = Color(0xFF2E6BFF); // Biru Tua (Deep Blue)
const Color _backgroundColor = Color(0xFFF5F7FA); // Background soft light
const Color _textColor = Color(0xFF37474F); // Abu-abu gelap (Deep Grey)
const Color _fieldColor = Colors.white; // Warna isian field

// Catatan: Karena menggunakan Map, kita tidak perlu class KeluargaData.

class EditKeluargaPage extends StatefulWidget {
  // Terima data keluarga awal sebagai Map<String, dynamic>
  final Map<String, dynamic> initialData;

  const EditKeluargaPage({Key? key, required this.initialData}) : super(key: key);

  @override
  State<EditKeluargaPage> createState() => _EditKeluargaPageState();
}

class _EditKeluargaPageState extends State<EditKeluargaPage> {
  final _formKey = GlobalKey<FormState>();

  // --- State Variabel ---
  // Kita akan menggunakan variabel ini untuk menyimpan nilai yang diubah.
  late String _namaKeluarga;
  late String _kepalaKeluarga;
  late String _alamatRumah;
  String? _statusKepemilikan; 
  late String _status; 

  // Controller wajib untuk TextFormField jika menggunakan initial data
  late TextEditingController _namaKeluargaController;
  late TextEditingController _kepalaKeluargaController;
  late TextEditingController _alamatRumahController;

  // Opsi Dropdown untuk Status Kepemilikan
  final List<String> _kepemilikanOptions = ['Pemilik', 'Penyewa', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    // 1. Inisialisasi State dan Controller DARI MAP
    // Pastikan key yang digunakan (e.g., 'namaKeluarga') sesuai dengan Map Anda.
    
    // Konversi nilai int/null menjadi string jika diperlukan oleh Dropdown atau TextField.
    _namaKeluarga = widget.initialData['namaKeluarga'] ?? '';
    _kepalaKeluarga = widget.initialData['kepalaKeluarga'] ?? '';
    _alamatRumah = widget.initialData['alamatRumah'] ?? '';
    _statusKepemilikan = widget.initialData['statusKepemilikan']; // String?
    _status = widget.initialData['status'] ?? 'Aktif'; // Default ke 'Aktif' jika null

    _namaKeluargaController = TextEditingController(text: _namaKeluarga);
    _kepalaKeluargaController = TextEditingController(text: _kepalaKeluarga);
    _alamatRumahController = TextEditingController(text: _alamatRumah);
  }

  @override
  void dispose() {
    // Bersihkan controller
    _namaKeluargaController.dispose();
    _kepalaKeluargaController.dispose();
    _alamatRumahController.dispose();
    super.dispose();
  }

  // --- FUNGSI SUBMIT (Update Data) ---
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 2. Buat objek Map baru (update)
      final updatedKeluargaData = {
        // Asumsi 'no' adalah ID dan tidak berubah
        'no': widget.initialData['no'], 
        'namaKeluarga': _namaKeluarga,
        'kepalaKeluarga': _kepalaKeluarga,
        'alamatRumah': _alamatRumah,
        'statusKepemilikan': _statusKepemilikan,
        'status': _status,
        // Tambahkan key lain jika ada (misalnya: 'rt', 'rw', dll)
      };

      // Tampilkan SnackBar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Keluarga "${_namaKeluarga}" berhasil diubah!'),
          backgroundColor: Colors.orange, 
          duration: const Duration(seconds: 2),
        ),
      );

      // Kembali ke halaman sebelumnya dengan data Map yang diubah
      Navigator.pop(context, updatedKeluargaData);
    }
  }

  // --- FUNGSI RESET FORM (Kembali ke nilai awal) ---
  void _resetForm() {
    setState(() {
      // Reset state ke nilai initialData dari widget
      _namaKeluarga = widget.initialData['namaKeluarga'] ?? '';
      _kepalaKeluarga = widget.initialData['kepalaKeluarga'] ?? '';
      _alamatRumah = widget.initialData['alamatRumah'] ?? '';
      _statusKepemilikan = widget.initialData['statusKepemilikan'];
      _status = widget.initialData['status'] ?? 'Aktif'; 
      
      // Update controller
      _namaKeluargaController.text = _namaKeluarga;
      _kepalaKeluargaController.text = _kepalaKeluarga;
      _alamatRumahController.text = _alamatRumah;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulir direset ke data awal.'),
          duration: Duration(seconds: 1),
        ),
      );
  }

  // --------------------------------------------------------------------------
  // --- WIDGET PEMBANTU (Disesuaikan) ---
  // --------------------------------------------------------------------------

  // ... (Sisipkan semua widget helper: _buildCardField, _buildCardTextField, 
  // _buildCardDropdownField, _buildSectionHeader, _buildStatusSegmentedButton 
  // dari jawaban sebelumnya di sini) ...
  
  // NOTE: Saya akan menyertakan kembali widget pembantu secara ringkas agar kode ini lengkap

  Widget _buildCardField({
    required Widget child,
    required IconData icon,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 2), 
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _fieldColor, 
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(color: Colors.grey.shade300, width: 1), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: padding, 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: _primaryColor, size: 22), 
          const SizedBox(width: 10), 
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildCardTextField({
    required String label,
    required IconData icon,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    required TextEditingController controller, 
    int maxLines = 1,
  }) {
    return _buildCardField(
      icon: icon,
      child: TextFormField(
        controller: controller, 
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: _textColor.withOpacity(0.7), fontSize: 14), 
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0), 
        ),
        maxLines: maxLines,
        onSaved: onSaved,
        validator: validator,
        cursorColor: _primaryColor,
        style: const TextStyle(color: _textColor, fontSize: 14), 
      ),
    );
  }

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
          labelStyle: TextStyle(color: _textColor.withOpacity(0.7), fontSize: 14), 
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0), 
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(color: _textColor, fontSize: 14)), 
          );
        }).toList(),
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black87),
        icon: const Icon(Icons.keyboard_arrow_down, color: _primaryColor, size: 22), 
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), 
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: _primaryColor, width: 4)),
        ),
        padding: const EdgeInsets.only(left: 10), 
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold, 
            color: _textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSegmentedButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 6.0), 
          child: Text(
            'Status Keluarga:',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: _textColor), 
          ),
        ),
        SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: 'Aktif',
              label: Text('Aktif'),
              icon: Icon(Icons.check_circle_outline, size: 16), 
            ),
            ButtonSegment<String>(
              value: 'Nonaktif',
              label: Text('Nonaktif'),
              icon: Icon(Icons.cancel_outlined, size: 16), 
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), 
            textStyle: const TextStyle(fontSize: 14), 
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor, 
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0, 
        centerTitle: true, 
        title: const Text(
          'Edit Data Keluarga',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), 
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), 
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0), 
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // === BAGIAN 1: INFORMASI KELUARGA & ALAMAT ===
                      _buildSectionHeader('Informasi Keluarga & Alamat'),
                      const SizedBox(height: 14), 
                      
                      // 1. Nama Keluarga
                      _buildCardTextField(
                        label: 'Nama Keluarga',
                        icon: Icons.groups,
                        controller: _namaKeluargaController, 
                        onSaved: (value) => _namaKeluarga = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Nama keluarga wajib diisi' : null,
                      ),
                      const SizedBox(height: 16), 

                      // 2. Nama Kepala Keluarga
                      _buildCardTextField(
                        label: 'Nama Kepala Keluarga',
                        icon: Icons.person,
                        controller: _kepalaKeluargaController, 
                        onSaved: (value) => _kepalaKeluarga = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Nama kepala keluarga wajib diisi' : null,
                      ),
                      const SizedBox(height: 16), 

                      // 3. Alamat Rumah
                      _buildCardTextField(
                        label: 'Alamat Rumah',
                        icon: Icons.location_on,
                        controller: _alamatRumahController, 
                        maxLines: 2,
                        onSaved: (value) => _alamatRumah = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Alamat rumah wajib diisi' : null,
                      ),
                      const SizedBox(height: 24), 

                      // === BAGIAN 2: DETAIL KEPEMILIKAN & STATUS ===
                      _buildSectionHeader('Detail Kepemilikan & Status'),
                      const SizedBox(height: 14), 

                      // 4. Status Kepemilikan (Dropdown)
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
                      const SizedBox(height: 16), 

                      // 5. Status Keluarga (Segmented Button)
                      _buildStatusSegmentedButton(),
                      const SizedBox(height: 24), 

                      // Tombol Update dan Reset 
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.update, size: 18), 
                              label: const Text('SIMPAN PERUBAHAN'), 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor, 
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14), 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), 
                                ),
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold), 
                              ),
                            ),
                          ),
                          const SizedBox(width: 12), 
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _resetForm,
                              icon: const Icon(Icons.history, size: 18), 
                              label: const Text('RESET'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 14), 
                                side: const BorderSide(color: _primaryColor, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), 
                                ),
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold), 
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