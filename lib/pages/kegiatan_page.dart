import 'package:flutter/material.dart';

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({Key? key}) : super(key: key);

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  final List<Kegiatan> _kegiatanList = [
    Kegiatan(
      id: 1,
      nama: 'Rapat Koordinasi Bulanan',
      kategori: 'Rapat',
      penanggungJawab: 'Budi Santoso',
      tanggalPelaksanaan: '2024-01-15',
    ),
    Kegiatan(
      id: 2,
      nama: 'Pelatihan Flutter',
      kategori: 'Pelatihan',
      penanggungJawab: 'Siti Aminah',
      tanggalPelaksanaan: '2024-01-20',
    ),
    Kegiatan(
      id: 3,
      nama: 'Bakti Sosial',
      kategori: 'Sosial',
      penanggungJawab: 'Ahmad Rizki',
      tanggalPelaksanaan: '2024-01-25',
    ),
  ];

  final List<Kegiatan> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredList.addAll(_kegiatanList);
  }

  void _searchKegiatan(String query) {
    _filteredList.clear();
    if (query.isEmpty) {
      _filteredList.addAll(_kegiatanList);
    } else {
      _filteredList.addAll(
        _kegiatanList.where((kegiatan) =>
            kegiatan.nama.toLowerCase().contains(query.toLowerCase()) ||
            kegiatan.penanggungJawab.toLowerCase().contains(query.toLowerCase())),
      );
    }
    setState(() {});
  }

  void _filterByCategory(String category) {
    _filteredList.clear();
    if (category == 'Semua') {
      _filteredList.addAll(_kegiatanList);
    } else {
      _filteredList.addAll(
        _kegiatanList.where((kegiatan) => kegiatan.kategori == category),
      );
    }
    setState(() {});
  }

  void _showDetailDialog(Kegiatan kegiatan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Detail Kegiatan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF26A69A),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('No', '${kegiatan.id}'),
              _buildDetailRow('Nama Kegiatan', kegiatan.nama),
              _buildDetailRow('Kategori', kegiatan.kategori),
              _buildDetailRow('Penanggung Jawab', kegiatan.penanggungJawab),
              _buildDetailRow('Tanggal Pelaksanaan', kegiatan.tanggalPelaksanaan),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tutup',
              style: TextStyle(color: const Color(0xFF26A69A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Kegiatan kegiatan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Kegiatan'),
        content: Text('Apakah Anda yakin ingin menghapus "${kegiatan.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteKegiatan(kegiatan);
              Navigator.pop(context);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteKegiatan(Kegiatan kegiatan) {
    setState(() {
      _kegiatanList.removeWhere((k) => k.id == kegiatan.id);
      _filteredList.removeWhere((k) => k.id == kegiatan.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kegiatan "${kegiatan.nama}" berhasil dihapus')),
    );
  }

  void _editKegiatan(Kegiatan kegiatan) {
    // Implementasi edit kegiatan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit kegiatan "${kegiatan.nama}"')),
    );
  }

  void _tambahKegiatan() {
    // Implementasi tambah kegiatan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tambah kegiatan baru')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kegiatan'),
        backgroundColor: const Color(0xFF26A69A),
        actions: [
          // Search Icon
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: KegiatanSearchDelegate(_kegiatanList),
              );
            },
          ),
          // Filter Icon
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              _selectedFilter = value;
              _filterByCategory(value);
            },
            itemBuilder: (context) => [
              'Semua',
              'Rapat',
              'Pelatihan',
              'Sosial',
              'Lainnya'
            ].map((category) {
              return PopupMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kegiatan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchKegiatan('');
                        },
                      )
                    : null,
              ),
              onChanged: _searchKegiatan,
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Semua', 'Rapat', 'Pelatihan', 'Sosial', 'Lainnya']
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category),
                          selected: _selectedFilter == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = category;
                              _filterByCategory(category);
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 16),
          // Info jumlah data
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Kegiatan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total: ${_filteredList.length} kegiatan',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tidak ada kegiatan ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.resolveWith(
                            (states) => const Color(0xFF26A69A).withOpacity(0.1)),
                        columns: [
                          DataColumn(
                            label: Text(
                              'Nama Kegiatan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF26A69A),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Aksi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF26A69A),
                              ),
                            ),
                          ),
                        ],
                        rows: _filteredList.map((kegiatan) {
                          return DataRow(cells: [
                            DataCell(
                              Container(
                                constraints: BoxConstraints(maxWidth: 300),
                                child: Text(
                                  kegiatan.nama,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.blue, size: 20),
                                    onPressed: () =>
                                        _showDetailDialog(kegiatan),
                                    tooltip: 'Lihat Detail',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, 
                                        color: Colors.green, size: 20),
                                    onPressed: () => _editKegiatan(kegiatan),
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, 
                                        color: Colors.red, size: 20),
                                    onPressed: () =>
                                        _showDeleteConfirmation(kegiatan),
                                    tooltip: 'Hapus',
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahKegiatan,
        backgroundColor: const Color(0xFF26A69A),
        child: Icon(Icons.add),
      ),
    );
  }
}

class KegiatanSearchDelegate extends SearchDelegate {
  final List<Kegiatan> kegiatanList;

  KegiatanSearchDelegate(this.kegiatanList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = kegiatanList.where((kegiatan) =>
        kegiatan.nama.toLowerCase().contains(query.toLowerCase()) ||
        kegiatan.penanggungJawab.toLowerCase().contains(query.toLowerCase()));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final kegiatan = results.elementAt(index);
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              kegiatan.nama,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penanggung Jawab: ${kegiatan.penanggungJawab}'),
                Text('Kategori: ${kegiatan.kategori}'),
                Text('Tanggal: ${kegiatan.tanggalPelaksanaan}'),
              ],
            ),
            trailing: Text(
              kegiatan.kategori,
              style: TextStyle(
                color: const Color(0xFF26A69A),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              close(context, kegiatan);
            },
          ),
        );
      },
    );
  }
}

class Kegiatan {
  final int id;
  final String nama;
  final String kategori;
  final String penanggungJawab;
  final String tanggalPelaksanaan;

  Kegiatan({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.penanggungJawab,
    required this.tanggalPelaksanaan,
  });
}