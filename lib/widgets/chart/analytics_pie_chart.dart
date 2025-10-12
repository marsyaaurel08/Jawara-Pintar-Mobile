import 'dart:math';
import 'package:flutter/material.dart';

class AnalyticsPieChart extends StatelessWidget {
  final Map<String, double> data;
  final List<Color>? palette;
  final double size;

  const AnalyticsPieChart({
    super.key,
    required this.data,
    this.palette,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    final colors = palette ?? [
      Colors.green.shade400,
      Colors.blue.shade400,
      Colors.orange.shade400,
      Colors.purple.shade300,
      Colors.red.shade300,
    ];

    final entries = data.entries.toList();
    final total = data.values.fold<double>(0, (a, b) => a + b);

    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _PiePainter(entries, colors),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(entries.length, (i) {
              final e = entries[i];
              final pct = total > 0 ? (e.value / total * 100) : 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[i % colors.length], borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.key, style: const TextStyle(fontSize: 13))),
                    const SizedBox(width: 8),
                    Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;
  final List<Color> colors;

  _PiePainter(this.entries, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()..style = PaintingStyle.fill;

    final total = entries.fold<double>(0, (a, b) => a + b.value);
    double startRads = -pi / 2;

    for (var i = 0; i < entries.length; i++) {
      final sweep = total > 0 ? (entries[i].value / total) * 2 * pi : 0.0;
      paint.color = colors[i % colors.length];
      canvas.drawArc(rect.deflate(0), startRads, sweep, true, paint);
      startRads += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) => oldDelegate.entries != entries || oldDelegate.colors != colors;
}

// cleaned imports
