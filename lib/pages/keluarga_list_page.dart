import 'package:flutter/material.dart';

// Definisi Warna Kustom
const Color primaryColor = Color(0xFFFFA726); // Orange Amber/Tangerine
const Color backgroundColor = Color(0xFFF5F7FA);

// Struktur Data Dummy (Sama)
class Keluarga {
  final int no;
  final String namaKeluarga;
  final String kepalaKeluarga;
  final String alamatRumah;
  final String statusKepemilikan;
  final String status; // Aktif/Nonaktif

  Keluarga({
    required this.no,
    required this.namaKeluarga,
    required this.kepalaKeluarga,
    required this.alamatRumah,
    required this.statusKepemilikan,
    required this.status,
  });
}

final List<Keluarga> dummyKeluargaList = [
  Keluarga(no: 1, namaKeluarga: 'Keluarga Farhan', kepalaKeluarga: 'Farhan', alamatRumah: 'Griyashanta L203', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  Keluarga(no: 2, namaKeluarga: 'Keluarga Rendha Putra Rahmadya', kepalaKeluarga: 'Rendha Putra Rahmadya', alamatRumah: 'Malang', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  Keluarga(no: 3, namaKeluarga: 'Keluarga Anti Micin', kepalaKeluarga: 'Anti Micin', alamatRumah: 'malang', statusKepemilikan: 'Penyewa', status: 'Aktif'),
  Keluarga(no: 4, namaKeluarga: 'Keluarga varezky naldiba rimra', kepalaKeluarga: 'varezky naldiba rimra', alamatRumah: 'i', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  Keluarga(no: 5, namaKeluarga: 'Keluarga lijat', kepalaKeluarga: 'lijat', alamatRumah: 'Keluar Wilayah', statusKepemilikan: 'Penyewa', status: 'Nonaktif'),
  Keluarga(no: 6, namaKeluarga: 'Keluarga Raudhli Firdaus Naufa', kepalaKeluarga: 'Raudhlil Firdaus Naufa', alamatRumah: 'Bogor Raya Permai F.J 2 no 11', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  Keluarga(no: 7, namaKeluarga: 'Keluarga Mara Nunez', kepalaKeluarga: 'Mara Nunez', alamatRumah: 'malang', statusKepemilikan: 'Pemilik', status: 'Aktif'),
  Keluarga(no: 8, namaKeluarga: 'Keluarga Habibie Ed Dien', kepalaKeluarga: 'Habibie Ed Dien', alamatRumah: 'Blok A49', statusKepemilikan: 'Pemilik', status: 'Aktif'),
];

class KeluargaListPage extends StatelessWidget {
  const KeluargaListPage({Key? key}) : super(key: key);

  // Widget untuk Badge Status (Sama)
  Widget _buildStatusBadge(String status) {
    Color color = status == 'Aktif' ? Colors.green.shade600 : Colors.red.shade600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(80),
      //   child: AppBar(
      //     backgroundColor: const Color.fromARGB(255, 5, 117, 209),
      //     elevation: 0,
      //     automaticallyImplyLeading: false,
      //     flexibleSpace: Container(
      //       decoration: const BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: [
      //             Color.fromARGB(255, 5, 117, 209),
      //             Color.fromARGB(255, 3, 95, 170),
      //           ],
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //         ),
      //       ),
      //       child: SafeArea(
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Row(
      //                 children: [
      //                   IconButton(
      //                     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //                     onPressed: () => Navigator.pop(context),
      //                   ),
      //                   const SizedBox(width: 4),
      //                   Container(
      //                     padding: const EdgeInsets.all(8),
      //                     decoration: BoxDecoration(
      //                       color: Colors.white.withOpacity(0.2),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     child: const Icon(
      //                       Icons.family_restroom_outlined,
      //                       color: Colors.white,
      //                       size: 24,
      //                     ),
      //                   ),
      //                   const SizedBox(width: 12),
      //                   const Text(
      //                     'Daftar Keluarga',
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 22,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: dummyKeluargaList.length,
        itemBuilder: (context, index) {
          final keluarga = dummyKeluargaList[index];
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              elevation: 4, // Memberi kesan mendalam
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                // Leading: Nomor urut atau Icon
                leading: CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Text(
                    keluarga.no.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                
                // Title: Nama Keluarga
                title: Text(
                  keluarga.namaKeluarga,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                
                // Subtitle: Kepala Keluarga & Alamat
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Kepala: ${keluarga.kepalaKeluarga}', style: TextStyle(color: Colors.grey.shade700)),
                    Text('Alamat: ${keluarga.alamatRumah}', style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(height: 4),
                    // Status Kepemilikan (Lebih detail di bawah)
                    Row(
                      children: [
                        Icon(Icons.home_work_outlined, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(keluarga.statusKepemilikan, style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
                
                // Trailing: Status Aktif/Nonaktif dan Aksi
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusBadge(keluarga.status),
                    PopupMenuButton<String>(
                      onSelected: (String result) {
                        // Aksi edit/detail/hapus
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('${result} untuk ${keluarga.namaKeluarga}')),
                        );
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(value: 'detail', child: Text('Detail')),
                        const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem<String>(value: 'hapus', child: Text('Hapus')),
                      ],
                    ),
                  ],
                ),
                
                isThreeLine: true,
                onTap: () {
                  // Aksi ketika item di-tap (misalnya navigasi ke Detail Keluarga)
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aksi tambah keluarga baru
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahKeluargaPage()));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Keluarga', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 6,
      ),
    );
  }
}