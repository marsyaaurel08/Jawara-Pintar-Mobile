import 'package:flutter/material.dart';
import '../../models/feature_item.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/slider_stat_card.dart';
import '../../widgets/feature_grid.dart';
import '../../../widgets/bottom_nav_scaffold.dart';
import 'analytics_page.dart';
import 'search_page.dart';
// removed: import '../../widgets/home_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  int dataIndex = 0;

  // SHORTCUTS sesuai requirement sistem kamu
  late final List<FeatureItem> features = [
    // 1. Tagihan
    FeatureItem(
      id: 'billing',
      title: 'Tagihan',
      icon: Icons.receipt_long,
      bg: const Color(0xFF5C6BC0),
      onTap: () {},
    ),

    // 2. Pemasukan
    FeatureItem(
      id: 'finance_income',
      title: 'Pemasukan',
      icon: Icons.arrow_downward,
      bg: const Color(0xFF43A047),
      onTap: () {},
    ),

    // 3. Pengeluaran
    FeatureItem(
      id: 'finance_expense',
      title: 'Pengeluaran',
      icon: Icons.arrow_upward,
      bg: const Color(0xFFE53935),
      onTap: () {},
    ),

    // 4. Penerimaan (Penerimaan warga)
    FeatureItem(
      id: 'approvals',
      title: 'Penerimaan',
      icon: Icons.verified_user_outlined,
      bg: const Color(0xFF7E57C2),
      onTap: () {},
    ),

    // 5. Data Warga
    FeatureItem(
      id: 'residents',
      title: 'Data Warga',
      icon: Icons.groups,
      bg: const Color(0xFF2E6BFF),
      onTap: () {
        /* TODO: Navigator.pushNamed(context, Routes.residents); */
      },
    ),

    // 6. Data Rumah
    FeatureItem(
      id: 'houses',
      title: 'Data Rumah',
      icon: Icons.home_work_outlined,
      bg: const Color(0xFF00BFA6),
      onTap: () {},
    ),

    // 7. Kegiatan
    FeatureItem(
      id: 'activities',
      title: 'Kegiatan',
      icon: Icons.event_note,
      bg: const Color(0xFF26A69A),
      onTap: () {},
    ),

    // 8. Broadcast
    FeatureItem(
      id: 'broadcast',
      title: 'Broadcast',
      icon: Icons.campaign_outlined,
      bg: const Color(0xFF42A5F5),
      onTap: () {},
    ),

    // 9. Aspirasi
    FeatureItem(
      id: 'complaints',
      title: 'Aspirasi',
      icon: Icons.mark_chat_unread_outlined,
      bg: const Color(0xFF8D6E63),
      onTap: () {},
    ),

    // 10. Laporan Keuangan (new placeholder)
    FeatureItem(
      id: 'finance_report',
      title: 'Laporan Keuangan',
      icon: Icons.bar_chart,
      bg: const Color(0xFF2E6BFF),
      onTap: () {},
    ),

    // 11. Iuran (new placeholder)
    FeatureItem(
      id: 'dues',
      title: 'Iuran',
      icon: Icons.payments,
      bg: const Color(0xFF43A047),
      onTap: () {},
    ),

    // 12. Mutasi Keluarga
    FeatureItem(
      id: 'mutations',
      title: 'Mutasi',
      icon: Icons.shuffle_on_outlined,
      bg: const Color(0xFF78909C),
      onTap: () {},
    ),

    // 13. Keluarga
    FeatureItem(
      id: 'families',
      title: 'Keluarga',
      icon: Icons.family_restroom,
      bg: const Color(0xFFFFA726),
      onTap: () {},
    ),

    // 14. Pengguna
    FeatureItem(
      id: 'users',
      title: 'Pengguna',
      icon: Icons.manage_accounts_outlined,
      bg: const Color(0xFF0097A7),
      onTap: () {},
    ),

    // 15. Channel transfer (new placeholder)
    FeatureItem(
      id: 'channel_transfer',
      title: 'Channel transfer',
      icon: Icons.compare_arrows,
      bg: const Color(0xFF5C6BC0),
      onTap: () {},
    ),

    // 16. Log aktivitas (new placeholder)
    FeatureItem(
      id: 'activity_log',
      title: 'Log aktivitas',
      icon: Icons.history,
      bg: const Color(0xFF78909C),
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (tab) {
      case 0:
        content = _buildBeranda();
        break;
      case 1:
        content = _buildData();
        break;
      case 2:
        content = _buildKeuangan();
        break;
      case 3:
        content = const AnalyticsPage();
        break;
      default:
        content = _buildBeranda();
    }

    return BottomNavScaffold(
      currentIndex: tab,
      onTap: (i) => setState(() => tab = i),
      body: SafeArea(child: content),
    );
  }

  Widget _buildBeranda() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const DashboardHeader(greeting: 'Selamat Pagi, Taufik', subtitle: ''),
          const SizedBox(height: 12),
          SliderStatCard(slides: buildDefaultSlides()),
          const SizedBox(height: 12),

          // search box - opens full screen search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SearchPage(features: features),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Color(0xFF2E6BFF)),
                    SizedBox(width: 8),
                    Text(
                      'Cari Fitur',
                      style: TextStyle(color: Color(0xFF2E6BFF)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FeatureGrid(items: features),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildData() {
    // Use a segmented control + AnimatedSize so the content can determine height
    // and match the Analytics tab switching visuals.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // segmented control similar to analytics
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: List.generate(3, (i) {
              final accent = i == 0
                  ? const Color(0xFF2E6BFF)
                  : i == 1
                  ? const Color(0xFF00BFA6)
                  : const Color(0xFFFFA726);
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => dataIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: i == dataIndex ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: i == dataIndex
                          ? [
                              BoxShadow(
                                color: accent.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                      border: Border(
                        left: BorderSide(
                          color: i == dataIndex ? accent : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        i == 0
                            ? 'Warga'
                            : i == 1
                            ? 'Rumah'
                            : 'Keluarga',
                        style: TextStyle(
                          fontWeight: i == dataIndex
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: i == dataIndex ? accent : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Content area - height adapts
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: IndexedStack(
            index: dataIndex,
            children: [
              // Warga
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.people, color: Color(0xFF2E6BFF)),
                        title: Text('Daftar Warga'),
                        subtitle: Text('Lihat, cari, dan kelola data warga'),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(child: Text('Daftar Warga (placeholder)')),
                  ],
                ),
              ),

              // Rumah
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.home, color: Color(0xFF00BFA6)),
                        title: Text('Daftar Rumah'),
                        subtitle: Text('Rekap dan peta rumah'),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(child: Text('Daftar Rumah (placeholder)')),
                  ],
                ),
              ),

              // Keluarga
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.family_restroom,
                          color: Color(0xFFFFA726),
                        ),
                        title: Text('Daftar Keluarga'),
                        subtitle: Text('Informasi per KK dan mutasi'),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(child: Text('Daftar Keluarga (placeholder)')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeuangan() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Keuangan', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.receipt_long,
                  color: Color(0xFF5C6BC0),
                ),
                title: const Text('Tagihan'),
                subtitle: const Text('Kelola tagihan dan status pembayaran'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.arrow_downward,
                  color: Color(0xFF43A047),
                ),
                title: const Text('Pemasukan'),
                subtitle: const Text('Rekap pemasukan'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.arrow_upward,
                  color: Color(0xFFE53935),
                ),
                title: const Text('Pengeluaran'),
                subtitle: const Text('Rekap pengeluaran'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.bar_chart, color: Color(0xFF2E6BFF)),
                title: const Text('Laporan'),
                subtitle: const Text('Ekspor laporan keuangan'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget _buildKegiatan() {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           Text(
  //             'Kegiatan & Broadcast',
  //             style: Theme.of(context).textTheme.titleLarge,
  //           ),
  //           const SizedBox(height: 12),
  //           // 'Kegiatan Terdekat' preview removed as requested.
  //           Card(
  //             child: ListTile(
  //               leading: const Icon(Icons.event, color: Color(0xFF26A69A)),
  //               title: const Text('Kegiatan'),
  //               subtitle: const Text('Daftar kegiatan warga'),
  //               trailing: const Icon(Icons.chevron_right),
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Card(
  //             child: ListTile(
  //               leading: const Icon(
  //                 Icons.campaign_outlined,
  //                 color: Color(0xFF42A5F5),
  //               ),
  //               title: const Text('Broadcast'),
  //               subtitle: const Text('Kirim pengumuman ke warga'),
  //               trailing: const Icon(Icons.chevron_right),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
