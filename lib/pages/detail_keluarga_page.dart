import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../pages/keluarga_list_page.dart';

// Definisi Warna Kustom (Konsisten dengan List Page)
const Color _primaryColor = Color(0xFF2E6BFF); // Biru Tua
const Color _secondaryColor = Color(0xFF00C853); // Hijau untuk Aktif
const Color _backgroundColor = Color(0xFFF5F7FA); // Background soft light
const Color _textColor = Color(0xFF37474F); // Abu-abu gelap
const Color _nonAktifColor = Colors.red; // Merah untuk Nonaktif
const Color _accentColor = Color(0xFFFFB300); // Kuning/Orange untuk Aksen

class DetailKeluargaPage extends StatelessWidget {
  final KeluargaData keluarga;

  const DetailKeluargaPage({Key? key, required this.keluarga}) : super(key: key);

  // Widget Pembantu untuk Badge Status
  Widget _buildStatusBadge(String status) {
    Color color = status == 'Aktif' ? _secondaryColor : _nonAktifColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        status == 'Aktif' ? 'AKTIF' : 'NONAKTIF',
        style: TextStyle(
            color: color, 
            fontWeight: FontWeight.bold, 
            fontSize: 14),
      ),
    );
  }

  // Widget untuk Detail Card
  Widget _buildDetailCard(IconData icon, String title, String value, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isPrimary ? _primaryColor : _textColor.withOpacity(0.7), size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isPrimary ? FontWeight.bold : FontWeight.w700,
                    color: isPrimary ? _primaryColor : _textColor,
                  ),
                  maxLines: title == "Alamat Rumah" ? 3 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Keluarga',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header (Nama Keluarga dan Status)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.groups_3, size: 36, color: _primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        keluarga.namaKeluarga,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildStatusBadge(keluarga.status),
                    ],
                  ),
                ),
              ],
            ),
            
            const Divider(height: 30, thickness: 1.5, color: Color(0xFFE0E0E0)),

            // Bagian Detail Informasi
            const Text(
              'Informasi Utama',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 15),

            _buildDetailCard(
              Icons.person_outline, 
              'Kepala Keluarga', 
              keluarga.kepalaKeluarga, 
              isPrimary: true
            ),

            _buildDetailCard(
              Icons.location_on_outlined, 
              'Alamat Rumah', 
              keluarga.alamatRumah
            ),

            _buildDetailCard(
              Icons.home_work_outlined, 
              'Status Kepemilikan', 
              keluarga.statusKepemilikan
            ),
            
            _buildDetailCard(
              Icons.format_list_numbered, 
              'Nomor Urut', 
              keluarga.no.toString()
            ),
            
            const SizedBox(height: 20),

            // Bagian Aksi Cepat
            const Text(
              'Aksi Cepat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Tombol Edit
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementasi navigasi ke EditKeluargaPage
                      // Anda mungkin perlu memanggil fungsi dari KeluargaListPage 
                      // atau mengimplementasikan navigasi di sini.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tekan tombol edit di List untuk mengedit data.')),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text('Edit Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Tombol Hapus
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implementasi konfirmasi hapus
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tekan tombol hapus di List untuk menghapus data.')),
                      );
                    },
                    icon: const Icon(Icons.delete, size: 20),
                    label: const Text('Hapus Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _nonAktifColor,
                      side: const BorderSide(color: _nonAktifColor, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}