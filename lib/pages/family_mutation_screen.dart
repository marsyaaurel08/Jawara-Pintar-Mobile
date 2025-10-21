import 'package:flutter/material.dart';

// --- Model Data (Untuk simulasi) ---
class MutationItem {
  final int no;
  final String tanggal;
  final String keluarga;
  final String jenisMutasi;

  MutationItem({
    required this.no,
    required this.tanggal,
    required this.keluarga,
    required this.jenisMutasi,
  });
}

// Data simulasi berdasarkan gambar
final List<MutationItem> mockMutationData = [
  MutationItem(
    no: 1,
    tanggal: '15 Oktober 2025',
    keluarga: 'Keluarga Iijat',
    jenisMutasi: 'Keluar Wilayah',
  ),
  MutationItem(
    no: 2,
    tanggal: '30 September 2025',
    keluarga: 'Keluarga Mara Nunez',
    jenisMutasi: 'Pindah Rumah',
  ),
  MutationItem(
    no: 3,
    tanggal: '24 Oktober 2026',
    keluarga: 'Keluarga Iijat',
    jenisMutasi: 'Pindah Rumah',
  ),
];

class FamilyMutationScreen extends StatelessWidget {
  const FamilyMutationScreen({super.key});

  // --- Widget untuk Chip Jenis Mutasi ---
  Widget _buildMutationChip(String mutasi) {
    Color color;
    switch (mutasi) {
      case 'Keluar Wilayah':
        color = Colors.red.shade600;
        break;
      case 'Pindah Rumah':
        color = Colors.green.shade600;
        break;
      default:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        mutasi,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // --- Card untuk setiap data mutasi ---
  Widget _buildMutationCard(BuildContext context, MutationItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            item.no.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          item.keluarga,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Tanggal: ${item.tanggal}',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 4),
            _buildMutationChip(item.jenisMutasi),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Aksi ${item.keluarga}: $value')),
            );
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Detail',
              child: Text('Lihat Detail'),
            ),
            const PopupMenuItem<String>(
              value: 'Hapus',
              child: Text('Hapus Mutasi'),
            ),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }

  // --- Fungsi untuk menampilkan Form Tambah Mutasi ---
  void _showAddMutationForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Penting untuk keyboard
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tambah Mutasi Keluarga',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                // Field Keluarga (Dropdown atau Searchable)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Pilih Keluarga',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.people),
                  ),
                ),
                const SizedBox(height: 16),
                // Field Jenis Mutasi (Dropdown)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Jenis Mutasi',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.swap_horiz),
                  ),
                ),
                const SizedBox(height: 16),
                // Field Tanggal (Date Picker)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Mutasi',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Gunakan Date Picker
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Logika Simpan Data Mutasi
                    Navigator.pop(context); // Tutup bottom sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mutasi berhasil ditambahkan!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('SIMPAN MUTASI'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 5, 117, 209),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 117, 209),
                  Color.fromARGB(255, 3, 95, 170),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.swap_horiz_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Mutasi Keluarga',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white),
                          onPressed: () {
                            // Aksi Filter
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: mockMutationData.length,
        itemBuilder: (context, index) {
          final item = mockMutationData[index];
          return _buildMutationCard(context, item);
        },
      ),

      // Tombol Tambah Mutasi (Floating Action Button)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMutationForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Mutasi'),
        backgroundColor: const Color(0xFF78909C),
        foregroundColor: Colors.white,
      ),
    );
  }
}
