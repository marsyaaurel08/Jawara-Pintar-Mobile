import 'package:flutter/material.dart';

enum AnalyticsRange { thisMonth, last3M, last6M, ytd, custom }

class AnalyticsFilters extends StatelessWidget {
  final AnalyticsRange selected;
  final void Function(AnalyticsRange) onRangeChanged;

  const AnalyticsFilters({
    super.key,
    required this.selected,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<AnalyticsRange>(
          value: selected,
          onChanged: (v) {
            if (v != null) onRangeChanged(v);
          },
          items: const [
            DropdownMenuItem(value: AnalyticsRange.thisMonth, child: Text('Bulan ini')),
            DropdownMenuItem(value: AnalyticsRange.last3M, child: Text('3 bln')),
            DropdownMenuItem(value: AnalyticsRange.last6M, child: Text('6 bln')),
            DropdownMenuItem(value: AnalyticsRange.ytd, child: Text('YTD')),
          ],
        ),
      ],
    );
  }
}
