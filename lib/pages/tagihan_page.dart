// file: lib/pages/tagihan_page.dart

import 'package:flutter/material.dart';

// Model data untuk item tagihan
class TagihanItem {
  final int no;
  final String nama;
  final String noKeluarga;
  final String iuran;
  final String kodeTagihan;
  final String status;
  final double jumlah;
  final String periode;
  // Tambahan field dummy untuk detail pop-up
  final String kategori;
  final String namaKK;
  final String alamatKK;
  final String metodePembayaran;
  final String kodeIuran;

  TagihanItem({
    required this.no,
    required this.nama,
    required this.noKeluarga,
    required this.iuran,
    required this.kodeTagihan,
    required this.status,
    required this.jumlah,
    required this.periode,
    this.kategori = 'Umum',
    this.namaKK = '-',
    this.alamatKK = '-',
    this.metodePembayaran = 'Belum tersedia',
    this.kodeIuran = '-',
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
      iuran: 'Mingguan',
      kodeTagihan: 'SKR001',
      status: 'Belum dibayarkan',
      jumlah: 10000,
      periode: '8 Oktober 2025',
      kategori: 'Iuran Khusus',
      namaKK: 'Keluarga Habibie Ed Dien',
      alamatKK: 'Blok A49',
      metodePembayaran: 'Belum tersedia',
      kodeIuran: 'IR175458A501',
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
      kategori: 'Iuran Rutin',
      namaKK: 'Keluarga Habibie Ed Dien',
      alamatKK: 'Blok A49',
      metodePembayaran: 'Transfer Bank',
      kodeIuran: 'IR175458A502',
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
      kategori: 'Iuran Rutin',
      namaKK: 'Keluarga Subroto',
      alamatKK: 'Jl. Merdeka 10',
      metodePembayaran: 'Belum tersedia',
      kodeIuran: 'IR175458A503',
    ),
  ];

  int? _expandedIndex;

  String _formatCurrency(double value) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${value.round().toString().replaceAllMapped(formatter, (Match m) => '${m[1]}.')}';
  }

  // Helper widget untuk baris detail di pop-up
  Widget _buildPopupDetailRow(
    String label,
    String value, {
    bool isStatus = false,
  }) {
    Color valueColor = Colors.black87;
    if (isStatus) {
      valueColor = value == 'unpaid'
          ? Colors.red.shade700
          : Colors.green.shade700;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // FUNGSI: Menampilkan Dialog Verifikasi Pembayaran
  // =============================================================
  void _showVerificationDialog(BuildContext context, TagihanItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String activeTab = 'Detail';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(16),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // HEADER (Tombol Back + Judul)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(
                              context,
                            ), // <-- ubah: tutup dialog
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Verifikasi Pembayaran Iuran',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // SEGMENTED CONTROL (Detail / Riwayat Pembayaran)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => activeTab = 'Detail'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: activeTab == 'Detail'
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: activeTab == 'Detail'
                                        ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Detail',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: activeTab == 'Detail'
                                            ? Colors.blue
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => activeTab = 'Riwayat'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: activeTab == 'Riwayat'
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: activeTab == 'Riwayat'
                                        ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Riwayat Pembayaran',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: activeTab == 'Riwayat'
                                            ? Colors.blue
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // === KONTEN SESUAI TAB ===
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: activeTab == 'Detail'
                          ? Padding(
                              key: const ValueKey('detail'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPopupDetailRow(
                                    'Kode Iuran',
                                    item.kodeIuran,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow(
                                    'Nama Iuran',
                                    item.iuran,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow(
                                    'Kategori',
                                    item.kategori,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow('Periode', item.periode),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow(
                                    'Nominal',
                                    _formatCurrency(item.jumlah),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow(
                                    'Status',
                                    item.status,
                                    isStatus: true,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow('Nama KK', item.namaKK),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow('Alamat', item.alamatKK),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow(
                                    'Metode Pembayaran',
                                    item.metodePembayaran,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPopupDetailRow('Bukti', ''),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Tulis alasan penolakan...',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            )
                          : Padding(
                              key: const ValueKey('riwayat'),
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Belum ada riwayat pembayaran.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                    ),

                    // === TOMBOL AKSI HANYA UNTUK TAB DETAIL ===
                    if (activeTab == 'Detail')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 8,
                                bottom: 16,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Pembayaran ${item.nama} disetujui!',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Setujui'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 16,
                                bottom: 16,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Pembayaran ${item.nama} ditolak.',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Tolak'),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =============================================================
  // List Item Iuran
  // =============================================================
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
          setState(() => _expandedIndex = isExpanded ? null : index);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
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
                  Expanded(
                    child: Text(
                      item.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ],
              ),
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
                            _showVerificationDialog(context, item);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
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
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.search, color: Colors.black54),
                    ],
                  ),
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
                itemBuilder: (context, index) =>
                    _buildIuranItem(context, _iuranList[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
