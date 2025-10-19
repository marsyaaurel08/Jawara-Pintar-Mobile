// file: lib/detail_warga_page.dart
import 'package:flutter/material.dart';

class DetailWargaPage extends StatelessWidget {
  final Map<String, dynamic> wargaData;

  const DetailWargaPage({super.key, required this.wargaData});

  static const Color _primaryColor = Color(0xFF2E6BFF);
  static const Color _accentColor = Color(0xFF00C853); // Hijau untuk status hidup

  // Widget pembantu untuk menampilkan satu baris detail dengan ikon
  Widget _buildDetailRow(IconData icon, String label, String value, {Color valueColor = Colors.black54}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: _primaryColor.withOpacity(0.7)),
          const SizedBox(width: 12),
          SizedBox(
            width: 120, // Lebar untuk label
            child: Text(
              '$label',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk header section
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Memastikan nilai tidak null atau diberi default string kosong/dash
    String formatValue(dynamic value) {
      if (value == null || value.toString().isEmpty) {
        return '-';
      }
      return value.toString();
    }

    // Ambil data dari map
    final data = wargaData;
    final String namaLengkap = formatValue(data['nama']);
    final String jenisKelamin = formatValue(data['jenisKelamin']);
    final Color statusColor = data['status'] == 'Hidup' ? _accentColor : Colors.red.shade700;
    final IconData profileIcon = jenisKelamin == 'Perempuan' ? Icons.female : Icons.male;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Warga',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: _primaryColor,
        iconTheme: const IconThemeData(color: Colors.white, size: 22),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- 1. Header Profil & Foto ---
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Foto Profil Placeholder
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: _primaryColor.withOpacity(0.15),
                        child: Icon(profileIcon, size: 40, color: _primaryColor),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaLengkap,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: _primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'NIK: ${formatValue(data['nik'])}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 2. Detail Informasi Personal (Card 1) ---
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Data Diri'),
                    const Divider(indent: 16, endIndent: 16, height: 1),
                    _buildDetailRow(Icons.person, 'Nama Lengkap', namaLengkap, valueColor: Colors.black87),
                    _buildDetailRow(Icons.cake, 'TTL', 
                        '${formatValue(data['tempatLahir'])}, ${formatValue(data['tanggalLahir'])}'),
                    _buildDetailRow(Icons.transgender, 'Jenis Kelamin', jenisKelamin),
                    _buildDetailRow(Icons.bloodtype, 'Gol. Darah', formatValue(data['golonganDarah'])),
                    _buildDetailRow(Icons.church, 'Agama', formatValue(data['agama'])),
                  ],
                ),
              ),

              // --- 3. Detail Kontak & Keluarga (Card 2) ---
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Kontak & Keluarga'),
                    const Divider(indent: 16, endIndent: 16, height: 1),
                    _buildDetailRow(Icons.phone, 'Telepon', formatValue(data['telepon'])),
                    _buildDetailRow(Icons.family_restroom, 'Keluarga', formatValue(data['keluarga'])),
                    _buildDetailRow(Icons.handshake, 'Peran Keluarga', formatValue(data['peranKeluarga'])),
                    _buildDetailRow(Icons.location_city, 'Domisili', formatValue(data['domisili'])),
                  ],
                ),
              ),

              // --- 4. Detail Pendidikan & Status (Card 3) ---
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Pekerjaan & Status'),
                    const Divider(indent: 16, endIndent: 16, height: 1),
                    _buildDetailRow(Icons.school, 'Pendidikan', formatValue(data['pendidikan'])),
                    _buildDetailRow(Icons.work, 'Pekerjaan', formatValue(data['pekerjaan'])),
                    _buildDetailRow(Icons.local_hospital, 'Status Hidup', formatValue(data['status']), valueColor: statusColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}