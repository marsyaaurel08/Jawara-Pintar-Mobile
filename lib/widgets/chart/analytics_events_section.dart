import 'package:flutter/material.dart';
import 'analytics_section_frame.dart';
import 'analytics_kpi_chip.dart';
import 'analytics_events_chart.dart';
import 'analytics_filters.dart';
import 'animated_entry.dart';

class AnalyticsEventsSection extends StatelessWidget {
  const AnalyticsEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedEntry(
      child: AnalyticsSectionFrame(
        title: 'Kegiatan - Bulan ini',
        filter: AnalyticsFilters(
          selected: AnalyticsRange.thisMonth,
          onRangeChanged: (_) {},
        ),
        kpiRow: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            AnalyticsKpiChip(title: 'Total Bulan ini', value: '42'),
            AnalyticsKpiChip(title: 'Hari ini', value: '3'),
            AnalyticsKpiChip(title: '7 hari', value: '8'),
            AnalyticsKpiChip(title: 'Selesai', value: '28'),
          ],
        ),
        chart: const AnalyticsEventsChart(),
        footer: TextButton(
          onPressed: () {},
          child: const Text('Buka Dashboard Kegiatan'),
        ),
      ),
    );
  }
}
