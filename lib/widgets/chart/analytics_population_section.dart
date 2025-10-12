import 'package:flutter/material.dart';
import 'analytics_section_frame.dart';
import 'analytics_kpi_chip.dart';
import 'analytics_population_chart.dart';
import 'analytics_filters.dart';
import 'animated_entry.dart';

class AnalyticsPopulationSection extends StatelessWidget {
  const AnalyticsPopulationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedEntry(
      child: AnalyticsSectionFrame(
        title: 'Kependudukan - Bulan ini',
        filter: AnalyticsFilters(selected: AnalyticsRange.thisMonth, onRangeChanged: (_) {}),
        kpiRow: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            AnalyticsKpiChip(title: 'Total Warga', value: '5.240'),
            AnalyticsKpiChip(title: 'Total KK', value: '1.820'),
            AnalyticsKpiChip(title: 'Total Rumah', value: '1.700'),
            AnalyticsKpiChip(title: 'Perubahan', value: '+24'),
          ],
        ),
        chart: const AnalyticsPopulationChart(),
        footer: TextButton(onPressed: () {}, child: const Text('Buka Dashboard Kependudukan')),
      ),
    );
  }
}
