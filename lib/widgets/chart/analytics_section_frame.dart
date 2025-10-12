import 'package:flutter/material.dart';

class AnalyticsSectionFrame extends StatelessWidget {
  final String title;
  final Widget? filter;
  final Widget kpiRow;
  final Widget chart;
  final Widget? footer;

  const AnalyticsSectionFrame({
    super.key,
    required this.title,
    this.filter,
    required this.kpiRow,
    required this.chart,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                if (filter != null) filter!,
              ],
            ),
            const SizedBox(height: 12),
            kpiRow,
            const SizedBox(height: 12),
            SizedBox(height: 240, child: chart),
            if (footer != null) ...[
              const SizedBox(height: 12),
              footer!,
            ]
          ],
        ),
      ),
    );
  }
}
