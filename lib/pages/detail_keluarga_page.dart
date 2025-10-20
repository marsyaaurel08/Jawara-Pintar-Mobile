import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tetap dipertahankan meskipun tidak digunakan untuk data dummy ini
import '../../pages/keluarga_list_page.dart';
import '../../pages/edit_keluarga_page.dart'; // Hanya untuk referensi path, tidak perlu import data

// Definisi Warna Kustom (Konsisten)
const Color _primaryColor = Color(0xFF2E6BFF); // Biru Tua
const Color _secondaryColor = Color(0xFF00C853); // Hijau untuk Aktif
const Color _backgroundColor = Color(0xFFF5F7FA); // Background soft light
const Color _textColor = Color(0xFF37474F); // Abu-abu gelap
const Color _nonAktifColor = Colors.red; // Merah untuk Nonaktif
const Color _accentColor = Color(0xFFFFB300); // Kuning/Orange untuk Aksen

class DetailKeluargaPage extends StatelessWidget {
  // Ganti tipe data dari KeluargaData menjadi Map<String, dynamic>
  final Map<String, dynamic> keluarga; 

  // Sesuaikan constructor
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
    // Ambil data dari Map. Gunakan `??` untuk fallback nilai jika null.
    final namaKeluarga = keluarga['namaKeluarga']?.toString() ?? 'Nama Keluarga Tidak Ditemukan';
    final status = keluarga['status']?.toString() ?? 'N/A';
    final kepalaKeluarga = keluarga['kepalaKeluarga']?.toString() ?? '-';
    final alamatRumah = keluarga['alamatRumah']?.toString() ?? '-';
    final statusKepemilikan = keluarga['statusKepemilikan']?.toString() ?? '-';
    final noUrut = keluarga['no']?.toString() ?? '0'; // Pastikan 'no' adalah key yang benar

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
                        namaKeluarga, // Akses data dari variabel lokal (Map)
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildStatusBadge(status), // Akses data dari variabel lokal (Map)
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
              kepalaKeluarga, // Akses data dari variabel lokal (Map)
              isPrimary: true
            ),

            _buildDetailCard(
              Icons.location_on_outlined, 
              'Alamat Rumah', 
              alamatRumah // Akses data dari variabel lokal (Map)
            ),

            _buildDetailCard(
              Icons.home_work_outlined, 
              'Status Kepemilikan', 
              statusKepemilikan // Akses data dari variabel lokal (Map)
            ),
            
            _buildDetailCard(
              Icons.format_list_numbered, 
              'Nomor Urut', 
              noUrut // Akses data dari variabel lokal (Map)
            ),
            
            const SizedBox(height: 20),

            // Bagian Aksi Cepat
            //const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}