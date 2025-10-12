import 'package:flutter/material.dart';
import '../../../routes.dart';
import '../../../theme.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/primary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailC = TextEditingController();
    final passC = TextEditingController();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // ======= HEADER BIRU DENGAN SUDUT MELENGKUNG =======
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

                    // ======= KONTEN =======
                    Column(
                      children: [
                        const SizedBox(height: 48),
                        // Brand Row
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
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                            decoration: BoxDecoration(
                              color: kCard,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Segmented tab (Login / Register)
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
                                          selected: true,
                                          onTap: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: _SegmentButton(
                                          text: 'Register',
                                          selected: false,
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            Routes.register,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),

                                const Text(
                                  'Selamat Datang,',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Login untuk mengakses sistem Jawara Pintar',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 18),

                                AppTextField(
                                  controller: emailC,
                                  label: 'Email',
                                  hint: 'Masukkan email aktif',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 12),
                                AppTextField(
                                  controller: passC,
                                  label: 'Password',
                                  hint: 'Masukkan password',
                                  prefixIcon: Icons.lock_outline,
                                  obscure: true,
                                ),
                                const SizedBox(height: 20),

                                PrimaryButton(
                                  text: 'Login',
                                  onPressed: () {
                                    // Validasi sederhana (mock)
                                    if (emailC.text.isEmpty ||
                                        passC.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Email dan password wajib diisi',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    // TODO: proses login mock
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //     content: Text('Login berhasil (mock)'),
                                    //   ),
                                    // );
                                    // // navigate to home (replace login)
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/home',
                                    );
                                  },
                                ),
                              ],
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

// Tombol segmen bulat (Login/Register)
class _SegmentButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _SegmentButton({
    required this.text,
    required this.selected,
    required this.onTap,
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
