import 'package:flutter/material.dart';
import '../../models/feature_item.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/slider_stat_card.dart';
import '../../widgets/feature_grid.dart';
import '../../../widgets/bottom_nav_scaffold.dart';
// removed: import '../../widgets/home_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;

  // SHORTCUTS sesuai requirement sistem kamu
  late final List<FeatureItem> features = [
    FeatureItem(
      id: 'residents',
      title: 'Data Warga',
      icon: Icons.groups,
      bg: const Color(0xFF2E6BFF),
      onTap: () {
        /* TODO: Navigator.pushNamed(context, Routes.residents); */
      },
    ),
    FeatureItem(
      id: 'houses',
      title: 'Data Rumah',
      icon: Icons.home_work_outlined,
      bg: const Color(0xFF00BFA6),
      onTap: () {},
    ),
    FeatureItem(
      id: 'families',
      title: 'Keluarga',
      icon: Icons.family_restroom,
      bg: const Color(0xFFFFA726),
      onTap: () {},
    ),
    FeatureItem(
      id: 'finance_income',
      title: 'Pemasukan',
      icon: Icons.arrow_downward,
      bg: const Color(0xFF43A047),
      onTap: () {},
    ),
    FeatureItem(
      id: 'finance_expense',
      title: 'Pengeluaran',
      icon: Icons.arrow_upward,
      bg: const Color(0xFFE53935),
      onTap: () {},
    ),
    FeatureItem(
      id: 'billing',
      title: 'Tagihan',
      icon: Icons.receipt_long,
      bg: const Color(0xFF5C6BC0),
      onTap: () {},
    ),
    FeatureItem(
      id: 'activities',
      title: 'Kegiatan',
      icon: Icons.event_note,
      bg: const Color(0xFF26A69A),
      onTap: () {},
    ),
    FeatureItem(
      id: 'broadcast',
      title: 'Broadcast',
      icon: Icons.campaign_outlined,
      bg: const Color(0xFF42A5F5),
      onTap: () {},
    ),
    // Lainnya
    FeatureItem(
      id: 'complaints',
      title: 'Aspirasi',
      icon: Icons.mark_chat_unread_outlined,
      bg: const Color(0xFF8D6E63),
      onTap: () {},
    ),
    FeatureItem(
      id: 'approvals',
      title: 'Penerimaan',
      icon: Icons.verified_user_outlined,
      bg: const Color(0xFF7E57C2),
      onTap: () {},
    ),
    FeatureItem(
      id: 'mutations',
      title: 'Mutasi',
      icon: Icons.shuffle_on_outlined,
      bg: const Color(0xFF78909C),
      onTap: () {},
    ),
    FeatureItem(
      id: 'users',
      title: 'Pengguna',
      icon: Icons.manage_accounts_outlined,
      bg: const Color(0xFF0097A7),
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
        content = _buildKegiatan();
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
          const DashboardHeader(
            greeting: 'Selamat Pagi, Taufik',
            subtitle: '',
          ),
          const SizedBox(height: 12),
          SliderStatCard(slides: buildDefaultSlides()),
          const SizedBox(height: 12),
          FeatureGrid(items: features),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildData() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TabBar(
              labelColor: const Color(0xFF2E6BFF),
              unselectedLabelColor: Colors.black54,
              indicator: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              tabs: const [
                Tab(text: 'Warga'),
                Tab(text: 'Rumah'),
                Tab(text: 'Keluarga'),
              ],
            ),
          ),
          SizedBox(
            height: 520,
            child: TabBarView(
              children: [
                Center(child: Text('Daftar Warga (placeholder)')),
                Center(child: Text('Daftar Rumah (placeholder)')),
                Center(child: Text('Daftar Keluarga (placeholder)')),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildKegiatan() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Kegiatan & Broadcast',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            // 'Kegiatan Terdekat' preview removed as requested.
            Card(
              child: ListTile(
                leading: const Icon(Icons.event, color: Color(0xFF26A69A)),
                title: const Text('Kegiatan'),
                subtitle: const Text('Daftar kegiatan warga'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.campaign_outlined,
                  color: Color(0xFF42A5F5),
                ),
                title: const Text('Broadcast'),
                subtitle: const Text('Kirim pengumuman ke warga'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
