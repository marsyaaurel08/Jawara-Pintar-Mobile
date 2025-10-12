import 'package:flutter/material.dart';

class AnalyticsEventsChart extends StatelessWidget {
  const AnalyticsEventsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [5, 8, 6, 10, 7]; // events per week (dummy)
    final max = data.reduce((a, b) => a > b ? a : b);

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
                          color: Colors.deepPurple.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('$v'),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
