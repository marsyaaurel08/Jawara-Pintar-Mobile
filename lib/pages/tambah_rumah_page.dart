import 'package:flutter/material.dart';

class TambahRumahPage extends StatefulWidget {
  const TambahRumahPage({Key? key}) : super(key: key);

  @override
  State<TambahRumahPage> createState() => _TambahRumahPageState();
}

class _TambahRumahPageState extends State<TambahRumahPage> {
  // --- Skema Warna Soft dan Konsisten (Mint/Teal) ---
  static const Color _primaryColor = Color(0xFF00C897); // Teal/Mint yang lembut
  static const Color _lightColor = Color(0xFFE0F7FA);   // Background soft
  static const Color _textColor = Color(0xFF37474F);    // Abu-abu gelap
  
  // Ukuran Font Disesuaikan untuk Mobile
  static const double _titleFontSize = 20.0;
  static const double _inputFontSize = 14.0;
  static const double _labelFontSize = 14.0;

  // --- Global Key untuk Form dan Controllers ---
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noRumahController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _luasController = TextEditingController();
  // Controller baru untuk Jenis Bangunan (sebelumnya dropdown)
  final TextEditingController _jenisBangunanController = TextEditingController(text: 'Permanen'); 
  
  // Status default saat penambahan rumah baru selalu 'Tersedia'
  final String _defaultStatus = 'Tersedia'; 

  @override
  void dispose() {
    _noRumahController.dispose();
    _alamatController.dispose();
    _luasController.dispose();
    _jenisBangunanController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // --- FUNGSI Aksi: Submit dan Reset ---
  // --------------------------------------------------------------------------

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final Map<String, dynamic> newRumah = {
        "no_rumah": _noRumahController.text.trim(),
        "alamat": _alamatController.text.trim(),
        "luas": int.tryParse(_luasController.text.trim()) ?? 0,
        "jenis": _jenisBangunanController.text.trim(), // Mengambil dari TextField
        "status": _defaultStatus, 
      };

      // TODO: Implementasi logika penambahan data ke list utama atau database
      
      // Tampilkan notifikasi sukses dan reset form
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Rumah No. ${newRumah['no_rumah']} berhasil ditambahkan!", style: const TextStyle(fontSize: _inputFontSize)),
          backgroundColor: _primaryColor,
        ),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _noRumahController.clear();
      _alamatController.clear();
      _luasController.clear();
      // Reset Jenis Bangunan ke nilai default
      _jenisBangunanController.text = 'Permanen';
      _formKey.currentState?.reset();
    });
  }

  // --------------------------------------------------------------------------
  // --- WIDGET UTAMA: BUILD ---
  // --------------------------------------------------------------------------
  
  // Helper: Widget untuk membangun TextField yang konsisten (font disesuaikan)
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String hintText = '',
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false, // Properti baru untuk field Jenis Bangunan
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      style: const TextStyle(fontSize: _inputFontSize, color: _textColor),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: _primaryColor, fontSize: _labelFontSize),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: _primaryColor, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText wajib diisi.';
        }
        if (keyboardType == TextInputType.number && int.tryParse(value) == null) {
          return '$labelText harus berupa angka.';
        }
        return null;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: _primaryColor,
        title: const Text('Tambah Rumah', style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Judul Utama Card
                  Text(
                    "Tambah Rumah Baru",
                    style: TextStyle(
                        fontWeight: FontWeight.w900, fontSize: _titleFontSize, color: _textColor),
                  ),
                  const Divider(height: 30, color: _primaryColor, thickness: 2),

                  // 1. Nomor Rumah
                  _buildTextField(
                    controller: _noRumahController,
                    labelText: 'Nomor Rumah',
                    hintText: 'Cth: 1A atau 005',
                  ),
                  const SizedBox(height: 20),

                  // 2. Alamat Rumah (Wajib ada)
                  _buildTextField(
                    controller: _alamatController,
                    labelText: 'Alamat Rumah',
                    hintText: 'Contoh: Jl. Merpati No. 5',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  
                  // 3. Jenis Bangunan (Text Field - sebelumnya Dropdown)
                  _buildTextField(
                    controller: _jenisBangunanController,
                    labelText: 'Jenis Bangunan',
                    hintText: 'Cth: Permanen',
                  ),
                  const SizedBox(height: 20),

                  // 4. Luas Bangunan (Number Input)
                   _buildTextField(
                    controller: _luasController,
                    labelText: 'Luas Bangunan (m²)',
                    hintText: 'Cth: 120 (gunakan angka)',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),

                  // 5. Tombol Aksi (Submit & Reset)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // Tombol Reset
                      OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textColor,
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _labelFontSize)),
                      ),
                      const SizedBox(width: 15),
                      // Tombol Submit
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _labelFontSize)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}