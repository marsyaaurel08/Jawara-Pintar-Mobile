import 'package:flutter/material.dart';
import '../../models/analytics/activities_summary.dart';
import '../../services/analytics_service.dart';
import '../../widgets/analytics/activities/time_based_kpi_cards.dart';
import '../../widgets/analytics/activities/category_pie_chart.dart';
import '../../widgets/analytics/activities/responsible_person_bar_chart.dart';
import '../../widgets/analytics/activities/monthly_activity_bar_chart.dart';

/// Activities Analytics Page
/// Menampilkan analitik kegiatan: jumlah kegiatan, partisipan, tingkat kehadiran
class ActivitiesAnalyticsPage extends StatefulWidget {
  const ActivitiesAnalyticsPage({super.key});

  @override
  State<ActivitiesAnalyticsPage> createState() =>
      _ActivitiesAnalyticsPageState();
}

class _ActivitiesAnalyticsPageState extends State<ActivitiesAnalyticsPage> {
  final _service = AnalyticsService();
  bool _loading = true;
  String? _error;
  ActivitiesSummary? _summary;
  List<ActivityType>? _types;
  List<ResponsiblePerson>? _responsiblePersons;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _service.fetchActivitiesAnalytics(),
        _service.fetchActivityTypes(),
        _service.fetchResponsiblePersons(),
      ]);

      setState(() {
        _summary = results[0] as ActivitiesSummary;
        _types = results[1] as List<ActivityType>;
        _responsiblePersons = results[2] as List<ResponsiblePerson>;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_summary == null) {
      return const Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // KPI Cards - Kegiatan Berdasarkan Waktu
            TimeBasedKpiCards(
              pastActivities: _summary!.pastActivities,
              todayActivities: _summary!.todayActivities,
              upcomingActivities: _summary!.upcomingActivities,
            ),
            const SizedBox(height: 24),

            // Pie Chart - Kategori Kegiatan
            CategoryPieChart(categories: _convertToPieData(_types ?? [])),
            const SizedBox(height: 24),

            // Bar Chart - Penanggung Jawab Terbanyak
            ResponsiblePersonBarChart(
              data: _convertToResponsibleData(_responsiblePersons ?? []),
              maxDisplay: 10,
            ),
            const SizedBox(height: 24),

            // Bar Chart - Kegiatan per Bulan
            MonthlyActivityBarChart(
              monthlyData: _convertToMonthlyData(_summary!.monthlyData),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk convert ActivityType ke CategoryPieData
  List<CategoryPieData> _convertToPieData(List<ActivityType> types) {
    final colors = [
      const Color(0xFFE91E63), // Pink - Komunitas & Sosial
      const Color(0xFF2196F3), // Blue - Kebersihan & Keamanan
      const Color(0xFF4CAF50), // Green - Keagamaan
      const Color(0xFFFF9800), // Orange - Pendidikan
      const Color(0xFF9C27B0), // Purple - Kesehatan & Olahraga
      const Color(0xFF607D8B), // Grey - Lainnya
    ];

    return types.asMap().entries.map((entry) {
      final index = entry.key;
      final type = entry.value;
      return CategoryPieData(
        category: type.type,
        count: type.count,
        percentage: type.percentage,
        color: colors[index % colors.length],
      );
    }).toList();
  }

  // Helper method untuk convert ResponsiblePerson ke ResponsiblePersonData
  List<ResponsiblePersonData> _convertToResponsibleData(
    List<ResponsiblePerson> persons,
  ) {
    return persons
        .map(
          (p) => ResponsiblePersonData(
            name: p.name,
            activitiesCount: p.activitiesCount,
          ),
        )
        .toList();
  }

  // Helper method untuk convert MonthlyActivity ke MonthlyActivityData
  List<MonthlyActivityData> _convertToMonthlyData(
    List<MonthlyActivity> monthly,
  ) {
    return monthly
        .map((m) => MonthlyActivityData(month: m.month, count: m.count))
        .toList();
  }
}
