// file: lib/pages/iuran_page.dart

import 'package:flutter/material.dart';

// Model data untuk item iuran (tagihan)
class TagihanItem {
  final int no;
  final String nama;
  final String noKeluarga;
  final String iuran;
  final String kodeTagihan;
  final String status;
  final double jumlah;
  final String periode;

  TagihanItem({
    required this.no,
    required this.nama,
    required this.noKeluarga,
    required this.iuran,
    required this.kodeTagihan,
    required this.status,
    required this.jumlah,
    required this.periode,
  });
}

class TagihanPage extends StatefulWidget {
  const TagihanPage({Key? key}) : super(key: key);

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  final List<TagihanItem> _iuranList = [
    TagihanItem(
      no: 1,
      nama: 'Sukarno',
      noKeluarga: 'Aktif',
      iuran: 'Sukarno',
      kodeTagihan: 'Sukarno',
      status: 'Belum dibayarkan',
      jumlah: 10000,
      periode: '8 Oktober 2025',
    ),
    TagihanItem(
      no: 2,
      nama: 'Habibie',
      noKeluarga: 'Aktif',
      iuran: 'Iuran Kebersihan',
      kodeTagihan: 'HBB002',
      status: 'Lunas',
      jumlah: 50000,
      periode: 'Oktober 2025',
    ),
    TagihanItem(
      no: 3,
      nama: 'Subroto',
      noKeluarga: 'Nonaktif',
      iuran: 'Iuran Keamanan',
      kodeTagihan: 'SBR003',
      status: 'Belum dibayarkan',
      jumlah: 25000,
      periode: 'Oktober 2025',
    ),
  ];

  // Index card yang sedang diperluas (expanded)
  int? _expandedIndex;

  String _formatCurrency(double value) {
    // Fungsi format mata uang sederhana (Rp x.xxx)
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${value.round().toString().replaceAllMapped(formatter, (Match m) => '${m[1]}.')}';
  }

  // Widget untuk Chip Aksi Filter/Tipe
  Widget _buildActionChip(String label, {bool isSelected = false}) {
    final color = isSelected ? const Color(0xFF585759) : Colors.grey.shade600;
    final bgColor = isSelected ? Colors.grey.shade300 : Colors.grey.shade100;
    final borderColor = isSelected
        ? Colors.grey.shade400
        : Colors.grey.shade300;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
    );
  }

  // Widget untuk Item List Iuran
  Widget _buildIuranItem(BuildContext context, TagihanItem item, int index) {
    final isExpanded = _expandedIndex == index;
    final cardBgColor = Colors.grey.shade200;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: cardBgColor,
      child: InkWell(
        onTap: () {
          setState(() {
            _expandedIndex = isExpanded ? null : index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Nomor Urut
                  Container(
                    width: 20,
                    alignment: Alignment.center,
                    child: Text(
                      '${item.no}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nama Warga
                  Expanded(
                    child: Text(
                      item.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // Tombol Expand/Collapse
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ],
              ),
              // Detail yang ditampilkan saat di-expand
              AnimatedCrossFade(
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
                firstChild: const SizedBox(height: 0),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDetailRow('Nama Keluarga', item.noKeluarga),
                        _buildDetailRow('Iuran', item.iuran),
                        _buildDetailRow(
                          'Jumlah',
                          _formatCurrency(item.jumlah),
                          isCurrency: true,
                        ),
                        _buildDetailRow('Periode', item.periode),
                        _buildDetailRow('Kode Tagihan', item.kodeTagihan),
                        _buildDetailRow('Status', item.status, isStatus: true),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Lihat detail tagihan'),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue, // Warna background
                            foregroundColor: Colors.white, // Warna teks
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Radius sudut
                            ),
                          ),
                          child: const Text('Detail'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk baris detail
  Widget _buildDetailRow(
    String label,
    String value, {
    bool isCurrency = false,
    bool isStatus = false,
  }) {
    Color valueColor = Colors.black87;
    if (isStatus) {
      valueColor = value == 'Belum dibayarkan'
          ? Colors.red.shade700
          : Colors.green.shade700;
    } else if (isCurrency) {
      valueColor = Colors.green.shade700;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header & Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(width: 8),
                    const Text(
                      'Tagihan', 
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Search Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black54,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      Icon(Icons.search, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildActionChip('Tagihan', isSelected: true),
                      _buildActionChip('Kategori Iuran'),
                      _buildActionChip('Pemasukan lain'),
                      _buildActionChip('Tagih Iuran', isSelected: false),
                      _buildActionChip('Cetak PDF'),
                    ],
                  ),
                ),
                // Icon Filter Kanan (Dipindah ke baris yang sama dengan Chip)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Tombol Tagih Iuran
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aksi: Tagih Iuran')),
                        );
                      },
                      icon: const Icon(
                        Icons.receipt_long,
                        size: 18,
                        color: Colors.black54,
                      ),
                      label: const Text(
                        'Tagih Iuran',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tombol Cetak PDF
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aksi: Cetak PDF')),
                        );
                      },
                      icon: const Icon(
                        Icons.picture_as_pdf,
                        size: 18,
                        color: Colors.black54,
                      ),
                      label: const Text(
                        'Cetak PDF',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Icon Filter
                    const Icon(Icons.filter_list, color: Colors.black54),
                  ],
                ),
              ],
            ),
          ),

          // Daftar Iuran
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: _iuranList.length,
                itemBuilder: (context, index) {
                  return _buildIuranItem(context, _iuranList[index], index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
