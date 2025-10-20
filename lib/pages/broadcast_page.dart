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
      isi: 'Rapat rutin bulanan akan dilaksanakan pada hari Sabtu, 20 Januari 2024 pukul 09.00 WIB di Balai RW. Agenda: evaluasi program bulan lalu dan perencanaan kegiatan mendatang.',
    ),
    Broadcast(
      id: '2',
      pengirim: 'Ketua RT',
      judul: 'Kerja Bakti Lingkungan',
      tanggal: DateTime(2024, 1, 10),
      isi: 'Akan diadakan kerja bakti membersihkan lingkungan sekitar pada Minggu, 21 Januari 2024 pukul 07.00 WIB. Mari bersama-sama menjaga kebersihan lingkungan.',
    ),
    Broadcast(
      id: '3',
      pengirim: 'Bendahara',
      judul: 'Iuran Bulan Januari',
      tanggal: DateTime(2024, 1, 5),
      isi: 'Segera bayar iuran bulan Januari 2024 paling lambat tanggal 10 Januari 2024. Pembayaran dapat dilakukan kepada bendahara atau melalui transfer ke rekening BCA 123-456-789.',
    ),
    Broadcast(
      id: '4',
      pengirim: 'Sekretaris',
      judul: 'Pendataan Warga Baru',
      tanggal: DateTime(2024, 1, 3),
      isi: 'Bagi warga yang baru pindah atau memiliki anggota keluarga baru, harap melapor ke sekretariat untuk keperluan administrasi dan pendataan.',
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
              const SizedBox(height: 12),
              const Text('Isi Broadcast:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  broadcast.isi,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
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
      isi: 'Ini adalah broadcast baru yang ditambahkan melalui fitur tambah broadcast.',
    );
    
    setState(() {
      _broadcasts.insert(0, newBroadcast);
      _filterBroadcasts();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Broadcast berhasil ditambahkan')),
    );
  }

  void _showActionMenu(BuildContext context, Broadcast broadcast) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.blue),
              title: const Text('Detail'),
              onTap: () {
                Navigator.pop(context);
                _showDetailDialog(broadcast);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit ${broadcast.judul}')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Hapus'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(broadcast);
              },
            ),
          ],
        ),
      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.campaign_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Broadcast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
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
      body: Column(
        children: [
          // Search Bar, Filter, dan Tambah dalam satu baris
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari judul broadcast...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
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
                ),
                const SizedBox(width: 12),
                
                // Filter Button
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: _showFilterDialog,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Tambah Button
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF42A5F5),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF42A5F5).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addBroadcast,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Daftar Broadcast dalam bentuk kartu
          Expanded(
            child: _filteredBroadcasts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada data broadcast',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: _filteredBroadcasts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final broadcast = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nomor Urut
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF42A5F5).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF42A5F5),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // Informasi Broadcast
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        broadcast.judul,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Pengirim: ${broadcast.pengirim}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Tanggal: ${broadcast.tanggal.day}/${broadcast.tanggal.month}/${broadcast.tanggal.year}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Tombol Aksi (Titik Tiga)
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'detail':
                                        _showDetailDialog(broadcast);
                                        break;
                                      case 'edit':
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Edit ${broadcast.judul}')),
                                        );
                                        break;
                                      case 'delete':
                                        _confirmDelete(broadcast);
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem<String>(
                                      value: 'detail',
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility, color: Colors.blue, size: 20),
                                          SizedBox(width: 8),
                                          Text('Detail'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.orange, size: 20),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red, size: 20),
                                          SizedBox(width: 8),
                                          Text('Hapus'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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