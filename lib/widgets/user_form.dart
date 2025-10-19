import 'package:flutter/material.dart';
import '../models/user.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  String _role = '';

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _phoneCtl.dispose();
    _passwordCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
  final id = DateTime.now().millisecondsSinceEpoch.toString();
    final user = UserModel(
      id: id,
      name: _nameCtl.text.trim(),
      email: _emailCtl.text.trim(),
      phone: _phoneCtl.text.trim(),
      role: _role.isEmpty ? 'Operator' : _role,
      status: 'Active',
      createdAt: DateTime.now(),
    );
    Navigator.of(context).pop(user);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Akun Pengguna', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtl,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap', hintText: 'Masukkan nama lengkap'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtl,
                      decoration: const InputDecoration(labelText: 'Email', hintText: 'Masukkan email aktif'),
                      validator: (v) => (v == null || !v.contains('@')) ? 'Email tidak valid' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneCtl,
                      decoration: const InputDecoration(labelText: 'Nomor HP', hintText: 'Masukkan nomor HP (cth: 08xxxxxxxxxx)'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordCtl,
                      decoration: const InputDecoration(labelText: 'Password', hintText: 'Masukkan password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmCtl,
                      decoration: const InputDecoration(labelText: 'Konfirmasi Password', hintText: 'Masukkan ulang password'),
                      obscureText: true,
                      validator: (v) => v != _passwordCtl.text ? 'Password tidak cocok' : null,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _role.isEmpty ? null : _role,
                      items: const [
                        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'Operator', child: Text('Operator')),
                        DropdownMenuItem(value: 'Viewer', child: Text('Viewer')),
                      ],
                      onChanged: (v) => setState(() => _role = v ?? ''),
                      decoration: const InputDecoration(labelText: 'Role', hintText: '-- Pilih Role --'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Reset'))),
                        const SizedBox(width: 12),
                        ElevatedButton(onPressed: _save, child: const Text('Simpan')),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
