import 'package:flutter/material.dart';

class AnalyticsKpiChip extends StatelessWidget {
  final String title;
  final String value;
  final String? delta;

  const AnalyticsKpiChip({
    super.key,
    required this.title,
    required this.value,
    this.delta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 88),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          if (delta != null) ...[
            const SizedBox(height: 6),
            Text(delta!, style: const TextStyle(fontSize: 11))
          ]
        ],
      ),
    );
  }
}
