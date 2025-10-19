import 'package:flutter/material.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  String? _keluarga;
  String? _nama;
  String? _nik;
  String? _telepon;
  String? _tempatLahir;
  DateTime? _tanggalLahir;
  String? _jenisKelamin;
  String? _agama;
  String? _golonganDarah;
  String? _peranKeluarga;
  String? _pendidikanTerakhir;
  String? _pekerjaan;
  String? _status;

  //final List<String> _listKeluarga = ['Keluarga A', 'Keluarga B'];
  final List<String> _listGender = ['Laki-laki', 'Perempuan'];
  final List<String> _listAgama = ['Islam', 'Kristen', 'Hindu', 'Budha', 'Katolik'];
  final List<String> _listGolonganDarah = ['A', 'B', 'AB', 'O'];
  final List<String> _listPeran = ['Ayah', 'Ibu', 'Anak'];
  final List<String> _listPendidikan = ['SD', 'SMP', 'SMA', 'S1', 'S2'];
  final List<String> _listPekerjaan = ['PNS', 'Wiraswasta', 'Pelajar'];
  final List<String> _listStatus = ['Aktif', 'Tidak Aktif'];

  // Warna kustom diubah menjadi Deep Purple
  static const Color _primaryColor = Colors.deepPurple;
  static const Color _accentColor = Colors.deepPurpleAccent;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data berhasil disimpan ✅'),
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _tanggalLahir = null;
      _keluarga = null;
      _jenisKelamin = null;
      _agama = null;
      _golonganDarah = null;
      _peranKeluarga = null;
      _pendidikanTerakhir = null;
      _pekerjaan = null;
      _status = null;
    });
  }

  Widget _buildTextField(
    String label,
    String hint,
    Function(String) onSaved, {
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
    int? maxLength,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      initialValue: initialValue ?? '',
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _primaryColor) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        counterText: '',
      ),
      keyboardType: keyboardType,
      onSaved: (value) => onSaved(value ?? ''),
      validator: (value) => (value == null || value.isEmpty) ? '$label tidak boleh kosong' : null,
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 14)),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Pilih $label',
        labelStyle: const TextStyle(color: _primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) => value == null ? 'Pilih $label' : null,
      isExpanded: true,
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor, // Warna header DatePicker
              onPrimary: Colors.white, // Warna teks di header
              onSurface: Colors.black87, // Warna teks di DatePicker
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Warga Baru', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: _primaryColor, // Warna AppBar
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon kembali
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            'Informasi Keluarga & Pribadi',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryColor),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField('Keluarga', 'Masukkan keluarga', (val) => _keluarga = val,
                            prefixIcon: Icons.family_restroom),
                        const SizedBox(height: 16),
                        _buildTextField('Nama', 'Masukkan nama lengkap', (val) => _nama = val,
                            prefixIcon: Icons.person_outline),
                        const SizedBox(height: 16),
                        _buildTextField('NIK', 'Masukkan NIK sesuai KTP (16 digit)', (val) => _nik = val,
                            keyboardType: TextInputType.number, maxLength: 16, prefixIcon: Icons.credit_card),
                        const SizedBox(height: 16),
                        _buildTextField('Nomor Telepon', 'Contoh: 081234567890', (val) => _telepon = val,
                            keyboardType: TextInputType.phone, prefixIcon: Icons.phone_android),
                        const SizedBox(height: 16),
                        _buildTextField('Tempat Lahir', 'Masukkan nama kota/kabupaten',
                            (val) => _tempatLahir = val, prefixIcon: Icons.location_city_outlined),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _selectDate,
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Tanggal Lahir',
                                hintText: 'Pilih tanggal lahir (dd/mm/yyyy)',
                                prefixIcon: const Icon(Icons.calendar_today, color: _primaryColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: _primaryColor, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              controller: TextEditingController(
                                text: _tanggalLahir == null
                                    ? ''
                                    : '${_tanggalLahir!.day.toString().padLeft(2, '0')}/${_tanggalLahir!.month.toString().padLeft(2, '0')}/${_tanggalLahir!.year}',
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty) ? 'Pilih Tanggal Lahir' : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                            'Jenis Kelamin', _jenisKelamin, _listGender, (val) => setState(() => _jenisKelamin = val)),
                        const SizedBox(height: 16),
                        _buildDropdown(
                            'Agama', _agama, _listAgama, (val) => setState(() => _agama = val)),
                        const SizedBox(height: 16),
                        _buildDropdown('Golongan Darah', _golonganDarah, _listGolonganDarah,
                            (val) => setState(() => _golonganDarah = val)),
                        const SizedBox(height: 16),
                        _buildDropdown('Peran Keluarga', _peranKeluarga, _listPeran,
                            (val) => setState(() => _peranKeluarga = val)),
                        const SizedBox(height: 16),
                        _buildDropdown('Pendidikan Terakhir', _pendidikanTerakhir, _listPendidikan,
                            (val) => setState(() => _pendidikanTerakhir = val)),
                        const SizedBox(height: 16),
                        _buildDropdown('Pekerjaan', _pekerjaan, _listPekerjaan,
                            (val) => setState(() => _pekerjaan = val)),
                        const SizedBox(height: 16),
                        _buildDropdown('Status', _status, _listStatus,
                            (val) => setState(() => _status = val)),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'SIMPAN DATA',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _resetForm,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _primaryColor,
                                  side: const BorderSide(color: _primaryColor, width: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'RESET FORM',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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