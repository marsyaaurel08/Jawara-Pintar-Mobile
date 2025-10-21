import 'package:flutter/material.dart';
import '../../pages/analytics/finance_analytics_page.dart';
import '../../pages/analytics/activities_analytics_page.dart';
import '../../pages/analytics/population_analytics_page.dart';

class AnalyticsTabSwitcher extends StatefulWidget {
  final int initialIndex;
  const AnalyticsTabSwitcher({super.key, this.initialIndex = 0});

  @override
  State<AnalyticsTabSwitcher> createState() => _AnalyticsTabSwitcherState();
}

class _AnalyticsTabSwitcherState extends State<AnalyticsTabSwitcher> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  void _onSegmentChanged(int newIndex) => setState(() => index = newIndex);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: List.generate(3, (i) {
              final accent = i == 0
                  ? const Color(0xFF2E6BFF)
                  : i == 1
                      ? const Color(0xFF26A69A)
                      : const Color(0xFF7E57C2);
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onSegmentChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: i == index ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(
                          color: i == index ? accent : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        i == 0 ? 'Keuangan' : i == 1 ? 'Kegiatan' : 'Kependudukan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: i == index ? FontWeight.w700 : FontWeight.w600,
                          color: i == index ? accent : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        // AnimatedSwitcher to smoothly swap the content widgets
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: IndexedStack(
            key: ValueKey(index),
            index: index,
            children: const [
              FinanceAnalyticsPage(),
              ActivitiesAnalyticsPage(),
              PopulationAnalyticsPage(),
            ],
          ),
        ),
      ],
    );
  }
}
