import 'package:flutter/material.dart';

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final List<Broadcast> _broadcasts = [
    Broadcast(
      id: '1',
      pengirim: 'Admin',
      judul: 'Rapat Rutin Bulanan',
      tanggal: DateTime(2024, 1, 15),
      isi: 'Rapat rutin bulanan akan dilaksanakan...',
    ),
    Broadcast(
      id: '2',
      pengirim: 'Ketua RT',
      judul: 'Kerja Bakti Lingkungan',
      tanggal: DateTime(2024, 1, 10),
      isi: 'Akan diadakan kerja bakti...',
    ),
    Broadcast(
      id: '3',
      pengirim: 'Bendahara',
      judul: 'Iuran Bulan Januari',
      tanggal: DateTime(2024, 1, 5),
      isi: 'Segera bayar iuran bulan Januari...',
    ),
  ];

  List<Broadcast> _filteredBroadcasts = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DateTime? _filterDate;

  @override
  void initState() {
    super.initState();
    _filteredBroadcasts = _broadcasts;
  }

  void _filterBroadcasts() {
    setState(() {
      _filteredBroadcasts = _broadcasts.where((broadcast) {
        final matchesSearch = broadcast.judul
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final matchesDate = _filterDate == null ||
            _isSameDay(broadcast.tanggal, _filterDate!);
        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Broadcast'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Tanggal'),
              subtitle: _filterDate == null
                  ? const Text('Semua tanggal')
                  : Text('${_filterDate!.day}/${_filterDate!.month}/${_filterDate!.year}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_filterDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _filterDate = null;
                        });
                        Navigator.pop(context);
                        _filterBroadcasts();
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, size: 20),
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _filterDate = selectedDate;
                        });
                        Navigator.pop(context);
                        _filterBroadcasts();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(Broadcast broadcast) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(broadcast.judul),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Pengirim', broadcast.pengirim),
              _buildDetailItem('Tanggal', 
                '${broadcast.tanggal.day}/${broadcast.tanggal.month}/${broadcast.tanggal.year}'),
              _buildDetailItem('Judul', broadcast.judul),
              const SizedBox(height: 8),
              const Text('Isi:',
                style: TextStyle(fontWeight: FontWeight.bold)),
              Text(broadcast.isi),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _confirmDelete(Broadcast broadcast) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Broadcast'),
        content: Text('Yakin ingin menghapus "${broadcast.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteBroadcast(broadcast);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _deleteBroadcast(Broadcast broadcast) {
    setState(() {
      _broadcasts.removeWhere((b) => b.id == broadcast.id);
      _filterBroadcasts();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Broadcast "${broadcast.judul}" dihapus')),
    );
  }

  void _addBroadcast() {
    // Navigasi ke halaman tambah broadcast
    // Untuk sementara kita tambahkan data dummy
    final newBroadcast = Broadcast(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pengirim: 'User Baru',
      judul: 'Broadcast Baru',
      tanggal: DateTime.now(),
      isi: 'Ini adalah broadcast baru yang ditambahkan',
    );
    
    setState(() {
      _broadcasts.insert(0, newBroadcast);
      _filterBroadcasts();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Broadcast berhasil ditambahkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast'),
        backgroundColor: const Color(0xFF42A5F5),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari judul broadcast...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          _filterBroadcasts();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _filterBroadcasts();
              },
            ),
          ),
          
          // Filter dan Tambah Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Filter Button
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
                    onPressed: _showFilterDialog,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF42A5F5),
                      side: const BorderSide(color: Color(0xFF42A5F5)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Tambah Button
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                    onPressed: _addBroadcast,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF42A5F5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tabel Broadcast
          Expanded(
            child: _filteredBroadcasts.isEmpty
                ? const Center(
                    child: Text('Tidak ada data broadcast'),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.grey[100],
                      ),
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Judul')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: _filteredBroadcasts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final broadcast = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')),
                            DataCell(
                              Text(
                                broadcast.judul,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility,
                                        size: 20),
                                    color: Colors.blue,
                                    onPressed: () =>
                                        _showDetailDialog(broadcast),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    color: Colors.orange,
                                    onPressed: () {
                                      // Navigasi ke halaman edit
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Edit ${broadcast.judul}')),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    color: Colors.red,
                                    onPressed: () =>
                                        _confirmDelete(broadcast),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class Broadcast {
  final String id;
  final String pengirim;
  final String judul;
  final DateTime tanggal;
  final String isi;

  Broadcast({
    required this.id,
    required this.pengirim,
    required this.judul,
    required this.tanggal,
    required this.isi,
  });
}