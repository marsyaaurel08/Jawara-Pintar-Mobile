import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';
import '../../../routes.dart';
import '../../../theme.dart';
import '../../../widgets/app_text_form_field.dart';
import '../../../widgets/app_dropdown.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/upload_box.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final namaC = TextEditingController();
  final nikC = TextEditingController();
  final emailC = TextEditingController();
  final telpC = TextEditingController();
  final passC = TextEditingController();
  final pass2C = TextEditingController();
  final alamatC = TextEditingController();

  // Dropdown states
  String? gender; // L / P
  String? rumah; // id rumah
  String? statusRumah; // Milik/kontrak/...

  // Mock data dropdown
  final _genderItems = const [
    DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
    DropdownMenuItem(value: 'P', child: Text('Perempuan')),
  ];

  final _rumahItems = const [
    DropdownMenuItem(value: 'A1', child: Text('Blok A1 / No. 01')),
    DropdownMenuItem(value: 'B5', child: Text('Blok B5 / No. 08')),
    DropdownMenuItem(value: 'C2', child: Text('Blok C2 / No. 10')),
  ];

  final _statusItems = const [
    DropdownMenuItem(value: 'milik', child: Text('Pemilik')),
    DropdownMenuItem(value: 'kontrak', child: Text('Penyewa')),
  ];

  // Upload state (mock)
  String? fileName;
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // HEADER BIRU
                    Container(
                      height: 230,
                      decoration: const BoxDecoration(
                        color: kPrimaryBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(160, 60),
                          bottomRight: Radius.elliptical(160, 60),
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        const SizedBox(height: 48),
                        // Brand
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: const [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.bookmark,
                                  color: kPrimaryBlue,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jawara Pintar Mobile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Manajemen keuangan & kegiatan warga',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Kartu putih
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Segmented tab
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F3F6),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _SegmentButton(
                                            text: 'Login',
                                            selected: false,
                                            onTap: () =>
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.login,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Expanded(
                                          child: _SegmentButton(
                                            text: 'Register',
                                            selected: true,
                                            onTap: null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 18),
                                  const Text(
                                    'Daftar Akun',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Lengkapi formulir untuk membuat akun',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  const SizedBox(height: 18),

                                  AppTextFormField(
                                    controller: namaC,
                                    label: 'Nama lengkap',
                                    hint: 'Masukkan nama lengkap',
                                    prefixIcon: Icons.person_outline,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Wajib diisi'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),

                                  AppTextFormField(
                                    controller: nikC,
                                    label: 'NIK',
                                    hint: 'Masukkan NIK sesuai KTP',
                                    prefixIcon: Icons.badge_outlined,
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v == null || v.isEmpty)
                                        return 'Wajib diisi';
                                      if (v.length < 8)
                                        return 'NIK tidak valid';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  AppTextFormField(
                                    controller: emailC,
                                    label: 'Email',
                                    hint: 'Masukkan email aktif',
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) =>
                                        (v == null || !v.contains('@'))
                                        ? 'Email tidak valid'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),

                                  AppTextFormField(
                                    controller: telpC,
                                    label: 'No Telepon',
                                    hint: '08xxxxxxxxx',
                                    prefixIcon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: (v) =>
                                        (v == null || v.length < 9)
                                        ? 'Nomor tidak valid'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),

                                  AppTextFormField(
                                    controller: passC,
                                    label: 'Password',
                                    hint: 'Masukkan password',
                                    prefixIcon: Icons.lock_outline,
                                    obscure: true,
                                    validator: (v) =>
                                        (v == null || v.length < 6)
                                        ? 'Min. 6 karakter'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),

                                  AppTextFormField(
                                    controller: pass2C,
                                    label: 'Konfirmasi Password',
                                    hint: 'Masukkan ulang password',
                                    prefixIcon: Icons.lock_reset_outlined,
                                    obscure: true,
                                    validator: (v) => (v != passC.text)
                                        ? 'Password tidak sama'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),

                                  AppDropdown<String>(
                                    label: 'Jenis Kelamin',
                                    hint: '-- Pilih Jenis Kelamin --',
                                    value: gender,
                                    items: _genderItems,
                                    onChanged: (v) =>
                                        setState(() => gender = v),
                                    validator: (v) =>
                                        v == null ? 'Pilih salah satu' : null,
                                  ),
                                  const SizedBox(height: 12),

                                  AppDropdown<String>(
                                    label: 'Pilih Rumah yang Sudah Ada',
                                    hint: '-- Pilih Rumah --',
                                    value: rumah,
                                    items: _rumahItems,
                                    onChanged: (v) => setState(() => rumah = v),
                                    validator: (v) => null, // opsional
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    '*Jika rumah tidak ada di list, silakan isi alamat rumah di bawah',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  AppTextFormField(
                                    controller: alamatC,
                                    label:
                                        'Alamat Rumah (Jika Tidak Ada di List)',
                                    hint: 'Blok 5A / No.10',
                                    prefixIcon: Icons.home_outlined,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 12),

                                  AppDropdown<String>(
                                    label: 'Status kepemilikan rumah',
                                    hint: '-- Pilih Status --',
                                    value: statusRumah,
                                    items: _statusItems,
                                    onChanged: (v) =>
                                        setState(() => statusRumah = v),
                                    validator: (v) =>
                                        v == null ? 'Pilih status' : null,
                                  ),
                                  const SizedBox(height: 12),

                                  UploadBox(
                                    label: 'Foto Identitas',
                                    fileName: fileName,
                                    imagePath: filePath,
                                    onTap: () async {
                                      // pilih gambar dari gallery
                                      try {
                                        final ImagePicker _picker =
                                            ImagePicker();
                                        final XFile? image = await _picker
                                            .pickImage(
                                              source: ImageSource.gallery,
                                            );
                                        if (image == null) return;

                                        final path = image.path;
                                        final ext = path
                                            .split('.')
                                            .last
                                            .toLowerCase();
                                        if (!(ext == 'png' ||
                                            ext == 'jpg' ||
                                            ext == 'jpeg')) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Format file harus .png atau .jpg',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        setState(() {
                                          filePath = path;
                                          fileName = path
                                              .split(Platform.pathSeparator)
                                              .last;
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Gagal pilih file: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 18),
                                  PrimaryButton(
                                    text: 'Buat Akun',
                                    onPressed: () {
                                      if (!formKey.currentState!.validate())
                                        return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Registrasi berhasil (mock)',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.pushReplacementNamed(
                                            context,
                                            Routes.login,
                                          ),
                                      child: const Text(
                                        'Sudah punya akun? Masuk',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Segmented tombol kecil (reuse gaya dari login)
class _SegmentButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap;
  const _SegmentButton({
    required this.text,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? kPrimaryBlue : Colors.black54,
          ),
        ),
      ),
    );
  }
}
