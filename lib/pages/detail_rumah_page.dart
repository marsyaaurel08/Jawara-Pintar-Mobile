import 'package:flutter/material.dart';

class DetailRumahPage extends StatelessWidget {
  final Map<String, dynamic> rumah;

  const DetailRumahPage({Key? key, required this.rumah}) : super(key: key);

  static const Color _primaryColor = Color(0xFF2E6BFF); // Biru Tua (Deep Blue)
  static const Color _accentColor = Color(0xFF00C853); // Hijau untuk Tersedia
  static const Color _textColor = Color(0xFF37474F); // Abu-abu gelap

  @override
  Widget build(BuildContext context) {
    final statusColor =
        rumah['status'] == 'Tersedia' ? _accentColor : _primaryColor;
    final List<Map<String, String>> riwayatPenghuni =
        (rumah['riwayat'] as List<dynamic>?)?.cast<Map<String, String>>() ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Detail Rumah",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Status Card (Epic Look) ---
            _buildStatusHeader(statusColor),
            const SizedBox(height: 16),

            // --- Info Detail Utama ---
            _buildInfoCard(
              title: "Informasi Utama",
              icon: Icons.info_outline,
              children: [
                _buildDetailRow("Nomor Rumah", rumah['no_rumah']),
                _buildDetailRow("Alamat", rumah['alamat'] ?? 'N/A'),
                _buildDetailRow(
                  "Status",
                  rumah['status'] ?? 'N/A',
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
                if (rumah['status'] == 'Ditempati')
                  _buildDetailRow(
                    "Penghuni Saat Ini",
                    rumah['penghuni'] ?? '-',
                    color: _primaryColor,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Spesifikasi Fisik Card ---
            _buildInfoCard(
              title: "Spesifikasi Fisik",
              icon: Icons.architecture_rounded,
              children: [
                _buildDetailRow("Jenis Bangunan", rumah['jenis'] ?? 'N/A'),
                _buildDetailRow("Luas", "${rumah['luas'] ?? 'N/A'} m²"),
              ],
            ),
            const SizedBox(height: 16),

            // --- Riwayat Penghuni Card ---
            _buildRiwayatCard(riwayatPenghuni),
          ],
        ),
      ),
    );
  }

  // Widget: Header Status
  Widget _buildStatusHeader(Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(
            rumah['status'] == 'Tersedia' ? Icons.check_circle_outline : Icons.group_outlined,
            color: statusColor,
            size: 35,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "STATUS SAAT INI",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Text(
                rumah['status'].toString().toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: statusColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget: Info Card dengan Judul
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  // Widget: Baris Detail
  Widget _buildDetailRow(
    String label,
    String value, {
    Color color = _textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: fontWeight,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget: Riwayat Penghuni Card
  Widget _buildRiwayatCard(List<Map<String, String>> riwayatPenghuni) {
    return _buildInfoCard(
      title: "Riwayat Penghuni",
      icon: Icons.history_toggle_off_rounded,
      children: [
        if (riwayatPenghuni.isEmpty)
          const Text(
            "Belum ada riwayat penghuni yang tercatat.",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              fontSize: 14.0,
            ),
          )
        else
          ...riwayatPenghuni
              .map(
                (riwayat) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        riwayat['nama']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.date_range, size: 14, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            "Periode: ${riwayat['periode']}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
      ],
    );
  }
}