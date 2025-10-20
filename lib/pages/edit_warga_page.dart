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
  // static const Color _accentColor = Color.fromARGB(255, 30, 76, 182); // Tidak digunakan, dihapus jika perlu

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
              primary: _primaryColor, 
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 18), // Font header DatePicker diperkecil
              labelLarge: TextStyle(fontSize: 14), // Font tombol DatePicker diperkecil
              bodyLarge: TextStyle(fontSize: 14), // Font hari diperkecil
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
          content: Text('Data Warga ${_nama} Berhasil Diperbarui! ✅', style: const TextStyle(fontSize: 14)), // Font SnackBar diperkecil
          backgroundColor: _primaryColor,
        ),
      );
      // Navigator.pop(context); // Go back to previous screen
    }
  }

  // Helper function for Text Fields (dengan penyesuaian font)
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
      style: const TextStyle(fontSize: 14), // Font input field diperkecil
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(fontSize: 14, color: _primaryColor), // Font label diperkecil
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500), // Font hint diperkecil
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _primaryColor, size: 20) : null, // Ukuran ikon diperkecil
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Sudut membulat
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14, // Diperkecil
          vertical: 12, // Diperkecil
        ),
        counterText: '', 
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

  // Helper function for Dropdown Fields (dengan penyesuaian font)
  Widget _buildDropdownField(
      String label, {
      required String hint,
      required String? value,
      required List<String> items,
      required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      style: const TextStyle(fontSize: 14, color: Colors.black87), // Font nilai terpilih diperkecil
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: _primaryColor, fontSize: 14), // Font label diperkecil
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500), // Font hint diperkecil
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Sudut membulat
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14, // Diperkecil
          vertical: 12, // Diperkecil
        ),
      ),
      value: value,
      hint: Text(hint, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)), // Font hint diperkecil
      isExpanded: true,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)))) // Font item diperkecil
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
        title: const Text('Edit Data Warga', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)), // Font Title AppBar diperkecil
        backgroundColor: _primaryColor, 
        iconTheme: const IconThemeData(color: Colors.white, size: 22), // Ukuran ikon kembali diperkecil
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding diperkecil
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Center(
                  child: Text(
                    'Perbarui Informasi Warga',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryColor), // Font heading diperkecil
                  ),
                ),
                const SizedBox(height: 16), // Jarak diperkecil

                // Nama Lengkap
                _buildTextField(
                  'Nama Lengkap',
                  'Masukkan Nama Lengkap',
                  (value) => _nama = value,
                  initialValue: _nama ?? '',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil

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
                const SizedBox(height: 12.0), // Jarak diperkecil

                // Keluarga 
                _buildTextField(
                  'Keluarga',
                  'Masukkan Nama Kepala Keluarga',
                  (value) => _keluarga = value,
                  initialValue: _keluarga ?? '',
                  prefixIcon: Icons.family_restroom_outlined,
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil

                // Telepon
                _buildTextField(
                  'Telepon',
                  'Masukkan Nomor Telepon',
                  (value) => _telepon = value,
                  keyboardType: TextInputType.phone,
                  initialValue: _telepon ?? '',
                  prefixIcon: Icons.phone_android,
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil

                // Tempat Lahir
                _buildTextField(
                  'Tempat Lahir',
                  'Masukkan Nama Kota/Kabupaten',
                  (value) => _tempatLahir = value,
                  initialValue: _tempatLahir ?? '',
                  prefixIcon: Icons.location_city_outlined,
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil

                // Tanggal Lahir (dengan styling InputDecorator yang konsisten)
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    hintText: 'Pilih tanggal lahir (dd/mm/yyyy)',
                    labelStyle: const TextStyle(color: _primaryColor, fontSize: 14), // Font label diperkecil
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500), // Font hint diperkecil
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Sudut membulat
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _primaryColor, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(14, 4, 4, 4), // Padding disesuaikan
                  ),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.calendar_today, color: _primaryColor, size: 20), // Ukuran ikon diperkecil
                          ),
                          Expanded(
                            child: Text(
                              _tanggalLahir == null
                                  ? 'Pilih Tanggal Lahir'
                                  : '${_tanggalLahir!.day.toString().padLeft(2, '0')}/${_tanggalLahir!.month.toString().padLeft(2, '0')}/${_tanggalLahir!.year}',
                              style: TextStyle(
                                fontSize: 14, // Font tanggal diperkecil
                                color: _tanggalLahir == null ? Colors.grey.shade500 : Colors.black87,
                              ),
                            ),
                          ),
                          if (_tanggalLahir != null)
                            IconButton(
                              icon: const Icon(Icons.close, size: 18), // Ukuran ikon diperkecil
                              color: Colors.grey,
                              onPressed: () => setState(() => _tanggalLahir = null),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil

                // Dropdowns
                _buildDropdownField(
                  'Jenis Kelamin',
                  hint: '-- Pilih Jenis Kelamin --',
                  value: _selectedJenisKelamin,
                  items: _jenisKelaminOptions,
                  onChanged: (newValue) => setState(() => _selectedJenisKelamin = newValue),
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil
                _buildDropdownField(
                  'Agama',
                  hint: '-- Pilih Agama --',
                  value: _selectedAgama,
                  items: _agamaOptions,
                  onChanged: (newValue) => setState(() => _selectedAgama = newValue),
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil
                _buildDropdownField(
                  'Golongan Darah',
                  hint: '-- Pilih Golongan Darah --',
                  value: _selectedGolonganDarah,
                  items: _golonganDarahOptions,
                  onChanged: (newValue) => setState(() => _selectedGolonganDarah = newValue),
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil
                _buildDropdownField(
                  'Peran Keluarga',
                  hint: '-- Pilih Peran Keluarga --',
                  value: _selectedPeranKeluarga,
                  items: _peranKeluargaOptions,
                  onChanged: (newValue) => setState(() => _selectedPeranKeluarga = newValue),
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil
                _buildDropdownField(
                  'Pendidikan Terakhir',
                  hint: '-- Pilih Pendidikan Terakhir --',
                  value: _selectedPendidikan,
                  items: _pendidikanOptions,
                  onChanged: (newValue) => setState(() => _selectedPendidikan = newValue),
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil
                _buildDropdownField(
                  'Pekerjaan',
                  hint: '-- Pilih Jenis Pekerjaan --',
                  value: _selectedPekerjaan,
                  items: _pekerjaanOptions,
                  onChanged: (newValue) => setState(() => _selectedPekerjaan = newValue),
                ),
                const SizedBox(height: 12.0), // Jarak diperkecil
                _buildDropdownField(
                  'Status',
                  hint: '-- Pilih Status --',
                  value: _selectedStatus,
                  items: _statusOptions,
                  onChanged: (newValue) => setState(() => _selectedStatus = newValue),
                ),
                const SizedBox(height: 24.0), // Jarak diperkecil

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
                          padding: const EdgeInsets.symmetric(vertical: 12), // Padding diperkecil
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Radius diperkecil
                          ),
                        ),
                        child: const Text('BATAL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Font tombol diperkecil
                      ),
                    ),
                    const SizedBox(width: 16), // Jarak diperkecil
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12), // Padding diperkecil
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Radius diperkecil
                          ),
                          elevation: 4, // Elevasi diperkecil
                        ),
                        child: const Text('SIMPAN PERUBAHAN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Font tombol diperkecil
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