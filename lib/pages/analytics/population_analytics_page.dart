import 'package:flutter/material.dart';
import '../../models/analytics/population_summary.dart';
import '../../services/analytics_service.dart';
import '../../widgets/analytics/population/population_kpi_cards.dart';
import '../../widgets/analytics/population/demographic_pie_chart.dart';

class PopulationAnalyticsPage extends StatefulWidget {
  const PopulationAnalyticsPage({super.key});

  @override
  State<PopulationAnalyticsPage> createState() =>
      _PopulationAnalyticsPageState();
}

class _PopulationAnalyticsPageState extends State<PopulationAnalyticsPage> {
  final _service = AnalyticsService();
  bool _loading = true;
  String? _error;
  PopulationSummary? _summary;
  List<ResidentStatus>? _residentStatus;
  List<Occupation>? _occupations;
  List<FamilyRole>? _familyRoles;
  List<Religion>? _religions;
  List<Education>? _educationLevels;
  GenderDistribution? _genderDist;

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
        _service.fetchPopulationAnalytics(),
        _service.fetchGenderDistribution(),
        _service.fetchResidentStatus(),
        _service.fetchOccupations(),
        _service.fetchFamilyRoles(),
        _service.fetchReligions(),
        _service.fetchEducationLevels(),
      ]);

      setState(() {
        _summary = results[0] as PopulationSummary;
        _genderDist = results[1] as GenderDistribution;
        _residentStatus = results[2] as List<ResidentStatus>;
        _occupations = results[3] as List<Occupation>;
        _familyRoles = results[4] as List<FamilyRole>;
        _religions = results[5] as List<Religion>;
        _educationLevels = results[6] as List<Education>;
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
            PopulationKpiCards(
              totalFamilies: _summary!.totalHouseholds,
              totalResidents: _summary!.totalResidents,
            ),
            const SizedBox(height: 24),
            DemographicPieChart(
              title: 'Status Penduduk',
              data: _convertStatusToPieData(_residentStatus ?? []),
              centerLabel: 'Total',
            ),
            const SizedBox(height: 16),
            DemographicPieChart(
              title: 'Jenis Kelamin',
              data: _convertGenderToPieData(_genderDist),
              centerLabel: 'Total',
            ),
            const SizedBox(height: 16),
            DemographicPieChart(
              title: 'Pekerjaan Penduduk',
              data: _convertOccupationToPieData(_occupations ?? []),
              centerLabel: 'Total',
            ),
            const SizedBox(height: 16),
            DemographicPieChart(
              title: 'Peran dalam Keluarga',
              data: _convertFamilyRoleToPieData(_familyRoles ?? []),
              centerLabel: 'Total',
            ),
            const SizedBox(height: 16),
            DemographicPieChart(
              title: 'Agama',
              data: _convertReligionToPieData(_religions ?? []),
              centerLabel: 'Total',
            ),
            const SizedBox(height: 16),
            DemographicPieChart(
              title: 'Tingkat Pendidikan',
              data: _convertEducationToPieData(_educationLevels ?? []),
              centerLabel: 'Total',
            ),
          ],
        ),
      ),
    );
  }

  List<DemographicPieData> _convertStatusToPieData(
    List<ResidentStatus> status,
  ) {
    return status.map((s) {
      return DemographicPieData(
        label: s.status,
        count: s.count,
        percentage: s.percentage,
        color: s.status == 'Aktif'
            ? const Color(0xFF4CAF50)
            : const Color(0xFFE53935),
      );
    }).toList();
  }

  List<DemographicPieData> _convertGenderToPieData(GenderDistribution? gender) {
    if (gender == null) return [];
    return [
      DemographicPieData(
        label: 'Laki-laki',
        count: gender.male,
        percentage: gender.malePercentage,
        color: const Color(0xFF2196F3),
      ),
      DemographicPieData(
        label: 'Perempuan',
        count: gender.female,
        percentage: gender.femalePercentage,
        color: const Color(0xFFE91E63),
      ),
    ];
  }

  List<DemographicPieData> _convertOccupationToPieData(
    List<Occupation> occupations,
  ) {
    final colors = [
      const Color(0xFF2196F3),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF00BCD4),
      const Color(0xFF607D8B),
    ];
    return occupations.asMap().entries.map((entry) {
      return DemographicPieData(
        label: entry.value.name,
        count: entry.value.count,
        percentage: entry.value.percentage,
        color: colors[entry.key % colors.length],
      );
    }).toList();
  }

  List<DemographicPieData> _convertFamilyRoleToPieData(List<FamilyRole> roles) {
    final colors = [
      const Color(0xFF1976D2),
      const Color(0xFFE91E63),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
    ];
    return roles.asMap().entries.map((entry) {
      return DemographicPieData(
        label: entry.value.role,
        count: entry.value.count,
        percentage: entry.value.percentage,
        color: colors[entry.key % colors.length],
      );
    }).toList();
  }

  List<DemographicPieData> _convertReligionToPieData(List<Religion> religions) {
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
    ];
    return religions.asMap().entries.map((entry) {
      return DemographicPieData(
        label: entry.value.name,
        count: entry.value.count,
        percentage: entry.value.percentage,
        color: colors[entry.key % colors.length],
      );
    }).toList();
  }

  List<DemographicPieData> _convertEducationToPieData(
    List<Education> education,
  ) {
    final colors = [
      const Color(0xFFFF9800),
      const Color(0xFF2196F3),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF607D8B),
    ];
    return education.asMap().entries.map((entry) {
      return DemographicPieData(
        label: entry.value.level,
        count: entry.value.count,
        percentage: entry.value.percentage,
        color: colors[entry.key % colors.length],
      );
    }).toList();
  }
}
