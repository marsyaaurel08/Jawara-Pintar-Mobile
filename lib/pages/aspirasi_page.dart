import 'package:flutter/material.dart';

class AspirasiPage extends StatefulWidget {
  const AspirasiPage({super.key});

  @override
  State<AspirasiPage> createState() => _AspirasiPageState();
}

class _AspirasiPageState extends State<AspirasiPage> {
  final TextEditingController _searchController = TextEditingController();
  
  // Data dummy untuk contoh
  final List<Map<String, dynamic>> _AspirasiData = [
    {
      'id': 1,
      'pengirim': 'John Doe',
      'judul': 'Rapat Koordinasi Bulanan',
      'status': 'Diterima',
      'tanggal': '2024-01-15',
      'deskripsi': 'Rapat koordinasi untuk membahas progress bulanan'
    },
    {
      'id': 2,
      'pengirim': 'Jane Smith',
      'judul': 'Pelatihan Flutter',
      'status': 'Pending',
      'tanggal': '2024-01-20',
      'deskripsi': 'Pelatihan pengembangan aplikasi mobile dengan Flutter'
    },
    {
      'id': 3,
      'pengirim': 'Bob Johnson',
      'judul': 'Webinar Digital Marketing',
      'status': 'Ditolak',
      'tanggal': '2024-02-01',
      'deskripsi': 'Webinar tentang strategi digital marketing terbaru'
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDetailDialog(Map<String, dynamic> Aspirasi) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Aspirasi['judul']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Pengirim', Aspirasi['pengirim']),
                _buildDetailRow('Status', Aspirasi['status']),
                _buildDetailRow('Tanggal Dibuat', Aspirasi['tanggal']),
                _buildDetailRow('Deskripsi', Aspirasi['deskripsi']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('TUTUP'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _editStatus(Map<String, dynamic> Aspirasi) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newStatus = Aspirasi['status'];
        
        return AlertDialog(
          title: const Text('Ubah Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pilih status baru:'),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: newStatus,
                    onChanged: (String? value) {
                      setState(() {
                        newStatus = value!;
                      });
                    },
                    items: ['Diterima', 'Pending', 'Ditolak']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('BATAL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Aspirasi['status'] = newStatus;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Status berhasil diubah menjadi $newStatus'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('SIMPAN'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAspirasi(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Aspirasi'),
          content: const Text('Apakah Anda yakin ingin menghapus Aspirasi ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('BATAL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _AspirasiData.removeWhere((item) => item['id'] == id);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aspirasi berhasil dihapus'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Header dengan background biru muda
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60.0,
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50, 
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Aspirasi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Search bar dan filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari Aspirasi...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Implementasi filter
                    },
                  ),
                ),
              ],
            ),
          ),

          // Daftar kartu Aspirasi
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: _AspirasiData.length,
                itemBuilder: (context, index) {
                  final Aspirasi = _AspirasiData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Nomor urut
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Informasi Aspirasi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Aspirasi['judul'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Pengirim: ${Aspirasi['pengirim']}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(Aspirasi['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getStatusColor(Aspirasi['status']),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              Aspirasi['status'],
                              style: TextStyle(
                                color: _getStatusColor(Aspirasi['status']),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Menu dropdown (tiga titik)
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              switch (value) {
                                case 'detail':
                                  _showDetailDialog(Aspirasi);
                                  break;
                                case 'edit':
                                  _editStatus(Aspirasi);
                                  break;
                                case 'delete':
                                  _deleteAspirasi(Aspirasi['id']);
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'detail',
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_red_eye, size: 18),
                                    SizedBox(width: 8),
                                    Text('Detail'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Edit Status'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Hapus', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}