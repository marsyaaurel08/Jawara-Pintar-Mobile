import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile/widgets/analytics/analytics_tab_switcher.dart';

class AnalyticsPage extends StatefulWidget {
  final int initialTab;
  const AnalyticsPage({super.key, this.initialTab = 0});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(19),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Analitik',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnalyticsTabSwitcher(initialIndex: widget.initialTab),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
