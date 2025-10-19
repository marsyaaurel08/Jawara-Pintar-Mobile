import 'package:flutter/material.dart';
import '../../models/feature_item.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/slider_stat_card.dart';
import '../../widgets/feature_grid.dart';
import '../../../widgets/bottom_nav_scaffold.dart';
import 'analytics_page.dart';
import 'search_page.dart';
import '../routes.dart';
// removed: import '../../widgets/home_preview.dart';
import '../../routes.dart';
import '../../pages/warga_list_page.dart';
import '../../pages/rumah_list_page.dart';
import '../../pages/keluarga_list_page.dart';
import 'user_management_page.dart';

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
        Navigator.pushNamed(context, Routes.tagihan,);
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WargaListPage()),
        );
      },
    ),
    // 6. Data Rumah
    FeatureItem(
      id: 'houses',
      title: 'Data Rumah',
      icon: Icons.home_work_outlined,
      bg: const Color(0xFF00BFA6),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RumahListPage()),
        );
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
        Navigator.pushNamed(context, Routes.report);
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KeluargaListPage()),
        );
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
    // Use a segmented control + AnimatedSize so the content can determine height
    // and match the Analytics tab switching visuals.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title for Kependudukan tab
        Padding(
          padding: const EdgeInsets.all(19),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Kependudukan',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(height: 12),
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
            // Title for Keuangan tab
            Padding(
              padding: const EdgeInsets.all(19),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Keuangan',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 12),
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
                onTap: () {
                  Navigator.pushNamed(context, Routes.income);
                },
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
                onTap: () {
                  Navigator.pushNamed(context, Routes.expenses);
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.bar_chart, color: Color(0xFF2E6BFF)),
                title: const Text('Laporan'),
                subtitle: const Text('Ekspor laporan keuangan'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, Routes.report);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
