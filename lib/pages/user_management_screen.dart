import 'package:flutter/material.dart';
import '../widgets/app_search_field.dart';

// =============================================================
// MODEL DATA
// =============================================================
class User {
  final int no;
  final String name;
  final String email;
  final String status;

  User({
    required this.no,
    required this.name,
    required this.email,
    required this.status,
  });
}

// Data dummy awal
final List<User> dummyUsers = [
  User(
    no: 1,
    name: 'dewqedwddw',
    email: 'admiwewen1@gmail.com',
    status: 'Diterima',
  ),
  User(
    no: 2,
    name: 'Rendha Putra Rahmadya',
    email: 'rendhazuper@gmail.com',
    status: 'Diterima',
  ),
  User(no: 3, name: 'bla', email: 'y@gmail.com', status: 'Diterima'),
  User(
    no: 4,
    name: 'Anti Micin',
    email: 'antimicin3@gmail.com',
    status: 'Diterima',
  ),
  User(no: 5, name: 'ijat4', email: 'ijat4@gmail.com', status: 'Diterima'),
  User(no: 6, name: 'ijat3', email: 'ijat3@gmail.com', status: 'Diterima'),
  User(no: 7, name: 'ijat2', email: 'ijat2@gmail.com', status: 'Diterima'),
  User(
    no: 8,
    name: 'AFIFAH KHOIRUNNISA',
    email: 'afi@gmail.com',
    status: 'Diterima',
  ),
];

// =============================================================
// STATUS CHIP
// =============================================================
class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  Color get color {
    switch (status) {
      case 'Diterima':
        return Colors.green.shade100;
      case 'Pending':
        return Colors.amber.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color get textColor {
    switch (status) {
      case 'Diterima':
        return Colors.green.shade800;
      case 'Pending':
        return Colors.amber.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// =============================================================
// HALAMAN UTAMA: User Management
// =============================================================
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<User> users = List.from(dummyUsers);

  // -------------------------------------------------------------
  // Fungsi tampilkan popup tambah pengguna
  // -------------------------------------------------------------
  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedStatus = 'Pending';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Pengguna'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Diterima', 'Pending'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nama dan email wajib diisi!'),
                    ),
                  );
                  return;
                }

                setState(() {
                  users.add(
                    User(
                      no: users.length + 1,
                      name: nameController.text,
                      email: emailController.text,
                      status: selectedStatus,
                    ),
                  );
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengguna berhasil ditambahkan!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------------
  // Tampilan utama
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Pengguna'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: const Icon(Icons.sort), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUserDialog, // 👈 panggil fungsi popup
        label: const Text('Tambah Pengguna'),
        icon: const Icon(Icons.add),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: AppSearchField(hint: 'Cari pengguna (nama atau email)...'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${user.no}. ${user.name}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Email: ${user.email}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Status:',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            StatusChip(status: user.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
