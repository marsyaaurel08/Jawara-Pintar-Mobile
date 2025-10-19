import 'package:flutter/material.dart';
import 'analytics_finance_section.dart';
import 'analytics_events_section.dart';
import 'analytics_population_section.dart';
import 'animated_entry.dart';

class AnalyticsTabSwitcher extends StatefulWidget {
  final int initialIndex;
  const AnalyticsTabSwitcher({super.key, this.initialIndex = 0});

  @override
  State<AnalyticsTabSwitcher> createState() => _AnalyticsTabSwitcherState();
}

class _AnalyticsTabSwitcherState extends State<AnalyticsTabSwitcher>
    with TickerProviderStateMixin {
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onSegmentChanged(int newIndex) {
    setState(() => index = newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // segmented control
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: i == index ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: i == index
                          ? [
                              BoxShadow(
                                color: accent.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                      border: Border(
                        left: BorderSide(
                          color: i == index ? accent : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        i == 0
                            ? 'Keuangan'
                            : i == 1
                            ? 'Kegiatan'
                            : 'Kependudukan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: i == index
                              ? FontWeight.w700
                              : FontWeight.w600,
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
        // Let the active tab content determine height to avoid overflow.
        // AnimatedSize provides a smooth transition when the content height changes.
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: IndexedStack(
            index: index,
            children: [
              AnimatedEntry(child: AnalyticsFinanceSection()),
              AnimatedEntry(child: AnalyticsEventsSection()),
              AnimatedEntry(child: AnalyticsPopulationSection()),
            ],
          ),
        ),
      ],
    );
  }
}
