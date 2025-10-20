import 'package:flutter/material.dart';
import '../../models/feature_item.dart';
import '../../widgets/home/dashboard_header.dart';
import '../../widgets/home/slider_stat_card.dart';
import '../../widgets/home/feature_grid.dart';
import '../../../widgets/bottom_nav_scaffold.dart';
import 'analytics_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'warga_list_page.dart';
import 'rumah_list_page.dart';
import 'keluarga_list_page.dart';
import 'keuangan/laporan.dart';
import '../routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  int dataIndex = 0;
  int analyticsInitialTab = 0;

  // SHORTCUTS sesuai requirement sistem kamu
  List<FeatureItem> get features => [
    // 1. Tagihan
    FeatureItem(
      id: 'billing',
      title: 'Tagihan',
      icon: Icons.receipt_long,
      bg: const Color(0xFF5C6BC0),
      onTap: () {
        Navigator.pushNamed(context, Routes.tagihan);
      },
    ),

    // 2. Pemasukan
    FeatureItem(
      id: 'finance_income',
      title: 'Pemasukan',
      icon: Icons.arrow_downward,
      bg: const Color(0xFF43A047),
      onTap: () {
        Navigator.pushNamed(context, Routes.income);
      },
    ),

    // 3. Pengeluaran
    FeatureItem(
      id: 'finance_expense',
      title: 'Pengeluaran',
      icon: Icons.arrow_upward,
      bg: const Color(0xFFE53935),
      onTap: () {
        Navigator.pushNamed(context, Routes.expenses);
      },
    ),

    // 4. Penerimaan (Penerimaan warga)
    FeatureItem(
      id: 'approvals',
      title: 'Penerimaan',
      icon: Icons.verified_user_outlined,
      bg: const Color(0xFF7E57C2),
      onTap: () {
        Navigator.pushNamed(context, Routes.approvals);
      },
    ),

    // 5. Data Warga
    FeatureItem(
      id: 'residents',
      title: 'Data Warga',
      icon: Icons.groups,
      bg: const Color(0xFF2E6BFF),
      onTap: () {
        // Arahkan ke navbar Kependudukan tab Warga
        setState(() {
          tab = 1;
          dataIndex = 0;
        });
      },
    ),
    // 6. Data Rumah
    FeatureItem(
      id: 'houses',
      title: 'Data Rumah',
      icon: Icons.home_work_outlined,
      bg: const Color(0xFF00BFA6),
      onTap: () {
        // Arahkan ke navbar Kependudukan tab Rumah
        setState(() {
          tab = 1;
          dataIndex = 1;
        });
      },
    ),

    // 7. Kegiatan
    FeatureItem(
      id: 'activities',
      title: 'Kegiatan',
      icon: Icons.event_note,
      bg: const Color(0xFF26A69A),
      onTap: () => Navigator.pushNamed(context, '/kegiatan'),
    ),

    // 8. Broadcast
    FeatureItem(
      id: 'broadcast',
      title: 'Broadcast',
      icon: Icons.campaign_outlined,
      bg: const Color(0xFF42A5F5),
      onTap: () => Navigator.pushNamed(context, '/broadcast'),
    ),

    // 9. Aspirasi
    FeatureItem(
      id: 'complaints',
      title: 'Aspirasi',
      icon: Icons.mark_chat_unread_outlined,
      bg: const Color(0xFF8D6E63),
      onTap: () => Navigator.pushNamed(context, '/aspirasi'),
    ),

    // 10. Laporan Keuangan (new placeholder)
    FeatureItem(
      id: 'finance_report',
      title: 'Laporan Keuangan',
      icon: Icons.bar_chart,
      bg: const Color(0xFF2E6BFF),
      onTap: () {
        // Arahkan ke navbar Keuangan (tab index 2)
        setState(() => tab = 2);
      },
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
      onTap: () {
        Navigator.pushNamed(context, Routes.mutations);
      },
    ),

    // 13. Keluarga
    FeatureItem(
      id: 'families',
      title: 'Keluarga',
      icon: Icons.family_restroom,
      bg: const Color(0xFFFFA726),
      onTap: () {
        // Arahkan ke navbar Kependudukan tab Keluarga
        setState(() {
          tab = 1;
          dataIndex = 2;
        });
      },
    ),

    // 14. Pengguna
    FeatureItem(
      id: 'users',
      title: 'Pengguna',
      icon: Icons.manage_accounts_outlined,
      bg: const Color(0xFF0097A7),
      onTap: () {
        Navigator.pushNamed(context, Routes.pengguna);
      },
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
      onTap: () {
        Navigator.pushNamed(context, Routes.activityLog);
      },
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
        content = AnalyticsPage(initialTab: analyticsInitialTab);
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
          DashboardHeader(
            title: 'Selamat datang',
            name: 'Taufik Dimas Edystara',
            onNotification: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada notifikasi baru')),
              );
            },
            onProfileTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const SizedBox(height: 12),
          SliderStatCard(
            onViewAnalytics: (analyticsIndex) {
              // switch bottom nav to Analitik and set which analytics sub-tab to show
              setState(() {
                analyticsInitialTab = analyticsIndex;
                tab = 3;
              });
            },
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // AppBar untuk Kependudukan dengan icon seperti Analitik
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 5, 117, 209),
                const Color.fromARGB(255, 3, 95, 170),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.people_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Kependudukan',
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
        const SizedBox(height: 16),
        // segmented control similar to analytics
        Container(
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
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

        // Content area - tampilkan page langsung
        Expanded(
          child: IndexedStack(
            index: dataIndex,
            children: [WargaListPage(), RumahListPage(), KeluargaListPage()],
          ),
        ),
      ],
    );
  }

  Widget _buildKeuangan() {
    // Langsung tampilkan halaman Laporan Keuangan
    return const LaporanPage();
  }
}
