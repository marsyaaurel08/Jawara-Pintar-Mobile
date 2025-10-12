import 'package:flutter/material.dart';

class AnalyticsFinanceChart extends StatelessWidget {
  final Color barColor;
  final List<int> data;

  const AnalyticsFinanceChart({
    super.key,
    this.barColor = Colors.blue,
    this.data = const [5000, 4200, 4800, 5200, 6100, 5800],
  });

  @override
  Widget build(BuildContext context) {
    final max = data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b) : 1;

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: data
              .map((v) => Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: (v / max) * 160,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: barColor.withOpacity(.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('${v.toString()}'),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
    });
  }
}
