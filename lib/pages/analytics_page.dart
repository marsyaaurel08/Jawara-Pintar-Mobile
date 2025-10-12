import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile/widgets/chart/analytics_tab_switcher.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Analitik'), centerTitle: true),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: AnalyticsTabSwitcher(),
          ),
        ),
      ),
    );
  }
}
