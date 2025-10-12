import 'package:flutter/material.dart';

class AnalyticsPopulationChart extends StatelessWidget {
  const AnalyticsPopulationChart({super.key});

  @override
  Widget build(BuildContext context) {
    // simple donut-like placeholder using stack
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(colors: [Colors.blue, Colors.pink, Colors.green, Colors.blue]),
              ),
            ),
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Center(child: Text('Gender')),
            ),
          ],
        ),
      ),
    );
  }
}
