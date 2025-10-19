import 'package:flutter/material.dart';

class EditWargaPage extends StatefulWidget {
  final Map<String, dynamic> wargaData;

  const EditWargaPage({Key? key, required this.wargaData}) : super(key: key);

  @override
  _EditWargaPageState createState() => _EditWargaPageState();
}

class _EditWargaPageState extends State<EditWargaPage> {
  final _formKey = GlobalKey<FormState>();

   // Warna kustom 
  static const Color _primaryColor = Color(0xFF2E6BFF);
  static const Color _accentColor = Color.fromARGB(255, 30, 76, 182);

  // State variables, initialized in initState
  String? _nama;
  String? _nik;
  String? _keluarga;
  String? _telepon;
  String? _tempatLahir;
  DateTime? _tanggalLahir;
  String? _selectedJenisKelamin;
  String? _selectedAgama;
  String? _selectedGolonganDarah;
  String? _selectedPeranKeluarga;
  String? _selectedPendidikan;
  String? _selectedPekerjaan;
  String? _selectedStatus;

  // Dropdown Options
  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _agamaOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
  ];
  final List<String> _golonganDarahOptions = [
    'A',
    'B',
    'AB',
    'O',
    'Tidak Tahu',
  ];
  final List<String> _peranKeluargaOptions = [
    'Kepala Keluarga',
    'Istri',
    'Anak',
    'Anggota Lain',
  ];
  final List<String> _pendidikanOptions = [
    'SD',
    'SMP',
    'SMA/SMK',
    'D1',
    'D3',
    'S1',
    'S2',
    'S3',
  ];
  final List<String> _pekerjaanOptions = [
    'PNS',
    'Swasta',
    'Wiraswasta',
    'Pelajar/Mahasiswa',
    'Lainnya',
  ];
  final List<String> _statusOptions = ['Hidup', 'Meninggal'];

  @override
  void initState() {
    super.initState();

    // Inisialisasi state dari widget.wargaData
    final data = widget.wargaData;

    _nama = data['nama'] ?? '';
    _nik = data['nik'] ?? '';
    _keluarga = data['keluarga'] ?? '';
    _telepon = data['telepon'] ?? '';
    _tempatLahir = data['tempatLahir'] ?? '';

    final tgl = data['tanggalLahir'];
    if (tgl is String) {
      _tanggalLahir = DateTime.tryParse(tgl);
    } else if (tgl is DateTime) {
      _tanggalLahir = tgl;
    } else {
      _tanggalLahir = null;
    }

    // Dropdown initialization (Safe check against options list)
    final jenisKelamin = data['jenisKelamin'];
    _selectedJenisKelamin =
        _jenisKelaminOptions.contains(jenisKelamin) ? jenisKelamin : null;

    final agama = data['agama'];
    _selectedAgama = _agamaOptions.contains(agama) ? agama : null;

    final golDarah = data['golonganDarah'];
    _selectedGolonganDarah =
        _golonganDarahOptions.contains(golDarah) ? golDarah : null;

    final peran = data['peranKeluarga'];
    _selectedPeranKeluarga =
        _peranKeluargaOptions.contains(peran) ? peran : null;

    final pendidikan = data['pendidikan'];
    _selectedPendidikan =
        _pendidikanOptions.contains(pendidikan) ? pendidikan : null;

    final pekerjaan = data['pekerjaan'];
    _selectedPekerjaan =
        _pekerjaanOptions.contains(pekerjaan) ? pekerjaan : null;

    final status = data['status'];
    _selectedStatus = _statusOptions.contains(status) ? status : null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor, // Deep Purple
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Warga ${_nama} Berhasil Diperbarui! ✅'),
          backgroundColor: _primaryColor,
        ),
      );
      Navigator.pop(context); // Go back to previous screen
    }
  }

  // Helper function for Text Fields (dengan styling baru)
  Widget _buildTextField(
    String label,
    String hint,
    Function(String?) onSaved, {
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
    int? maxLength,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _primaryColor) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), // Sudut membulat
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, // Diperlebar
          vertical: 14,
        ),
        counterText: '', // Menghilangkan penghitung karakter
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        if (maxLength != null &&
            value.length != maxLength &&
            (keyboardType == TextInputType.number || keyboardType == TextInputType.phone) &&
            label == 'NIK') {
          return '$label harus $maxLength digit';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  // Helper function for Dropdown Fields (dengan styling baru)
  Widget _buildDropdownField(
    String label, {
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      value: value,
      hint: Text(hint),
      isExpanded: true,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return '$label harus dipilih';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Warga', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: _primaryColor, // Warna AppBar Deep Purple
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding lebih besar
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Center(
                  child: Text(
                    'Perbarui Informasi Warga',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryColor),
                  ),
                ),
                const SizedBox(height: 20),

                // Nama Lengkap
                _buildTextField(
                  'Nama Lengkap',
                  'Masukkan Nama Lengkap',
                  (value) => _nama = value,
                  initialValue: _nama ?? '',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16.0),

                // NIK
                _buildTextField(
                  'NIK',
                  'Masukkan NIK (16 digit)',
                  (value) => _nik = value,
                  keyboardType: TextInputType.number,
                  initialValue: _nik ?? '',
                  maxLength: 16,
                  prefixIcon: Icons.credit_card,
                ),
                const SizedBox(height: 16.0),

                // Keluarga (Dibiarkan sebagai TextField sesuai permintaan struktur)
                _buildTextField(
                  'Keluarga',
                  'Masukkan Nama Kepala Keluarga',
                  (value) => _keluarga = value,
                  initialValue: _keluarga ?? '',
                  prefixIcon: Icons.family_restroom_outlined,
                ),
                const SizedBox(height: 16.0),

                // Telepon
                _buildTextField(
                  'Telepon',
                  'Masukkan Nomor Telepon',
                  (value) => _telepon = value,
                  keyboardType: TextInputType.phone,
                  initialValue: _telepon ?? '',
                  prefixIcon: Icons.phone_android,
                ),
                const SizedBox(height: 16.0),

                // Tempat Lahir
                _buildTextField(
                  'Tempat Lahir',
                  'Masukkan Nama Kota/Kabupaten',
                  (value) => _tempatLahir = value,
                  initialValue: _tempatLahir ?? '',
                  prefixIcon: Icons.location_city_outlined,
                ),
                const SizedBox(height: 16.0),

                // Tanggal Lahir (dengan styling InputDecorator yang konsisten)
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    hintText: 'Pilih tanggal lahir (dd/mm/yyyy)',
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
                    contentPadding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                  ),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.calendar_today, color: _primaryColor),
                          ),
                          Expanded(
                            child: Text(
                              _tanggalLahir == null
                                  ? 'Pilih Tanggal Lahir'
                                  : '${_tanggalLahir!.day.toString().padLeft(2, '0')}/${_tanggalLahir!.month.toString().padLeft(2, '0')}/${_tanggalLahir!.year}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _tanggalLahir == null ? Colors.grey[600] : Colors.black,
                              ),
                            ),
                          ),
                          if (_tanggalLahir != null)
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              color: Colors.grey,
                              onPressed: () => setState(() => _tanggalLahir = null),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Dropdowns
                _buildDropdownField(
                  'Jenis Kelamin',
                  hint: '-- Pilih Jenis Kelamin --',
                  value: _selectedJenisKelamin,
                  items: _jenisKelaminOptions,
                  onChanged: (newValue) => setState(() => _selectedJenisKelamin = newValue),
                ),
                const SizedBox(height: 16.0),
                _buildDropdownField(
                  'Agama',
                  hint: '-- Pilih Agama --',
                  value: _selectedAgama,
                  items: _agamaOptions,
                  onChanged: (newValue) => setState(() => _selectedAgama = newValue),
                ),
                const SizedBox(height: 16.0),
                _buildDropdownField(
                  'Golongan Darah',
                  hint: '-- Pilih Golongan Darah --',
                  value: _selectedGolonganDarah,
                  items: _golonganDarahOptions,
                  onChanged: (newValue) => setState(() => _selectedGolonganDarah = newValue),
                ),
                const SizedBox(height: 16.0),
                _buildDropdownField(
                  'Peran Keluarga',
                  hint: '-- Pilih Peran Keluarga --',
                  value: _selectedPeranKeluarga,
                  items: _peranKeluargaOptions,
                  onChanged: (newValue) => setState(() => _selectedPeranKeluarga = newValue),
                ),
                const SizedBox(height: 16.0),
                _buildDropdownField(
                  'Pendidikan Terakhir',
                  hint: '-- Pilih Pendidikan Terakhir --',
                  value: _selectedPendidikan,
                  items: _pendidikanOptions,
                  onChanged: (newValue) => setState(() => _selectedPendidikan = newValue),
                ),
                const SizedBox(height: 16.0),
                _buildDropdownField(
                  'Pekerjaan',
                  hint: '-- Pilih Jenis Pekerjaan --',
                  value: _selectedPekerjaan,
                  items: _pekerjaanOptions,
                  onChanged: (newValue) => setState(() => _selectedPekerjaan = newValue),
                ),
                const SizedBox(height: 16.0),
                _buildDropdownField(
                  'Status',
                  hint: '-- Pilih Status --',
                  value: _selectedStatus,
                  items: _statusOptions,
                  onChanged: (newValue) => setState(() => _selectedStatus = newValue),
                ),
                const SizedBox(height: 30.0),

                // Tombol Simpan dan Batal
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryColor,
                          side: const BorderSide(color: _primaryColor, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('BATAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
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
                        child: const Text('SIMPAN PERUBAHAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
  }
}