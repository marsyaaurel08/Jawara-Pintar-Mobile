import 'dart:math';
import 'package:flutter/material.dart';

enum PreviewState { loading, ready, empty, error }

/// Minimal, clean HomePreview implementation.
class HomePreview extends StatelessWidget {
  final String title;
  final String? seeAllRoute;
  final List<Widget> kpis;
  final Widget chart;
  final List<Widget> ctas;
  final PreviewState state;
  final double maxHeight;

  const HomePreview({
    super.key,
    required this.title,
    this.seeAllRoute,
    required this.kpis,
    required this.chart,
    required this.ctas,
    this.state = PreviewState.ready,
    this.maxHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700) ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

    return Semantics(
      container: true,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: titleStyle)),
                    if (seeAllRoute != null)
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, seeAllRoute!),
                        child: const Text('Lihat semua'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (state == PreviewState.loading) ...[
                  const SizedBox(height: 8),
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ] else if (state == PreviewState.error) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Gagal memuat data',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                ] else if (state == PreviewState.empty) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Belum ada data',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: 54,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) => kpis[i],
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: kpis.length,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(height: 110, child: chart),
                  const SizedBox(height: 10),
                  if (ctas.isNotEmpty)
                    Row(
                      children: ctas
                          .map(
                            (w) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: w,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KpiChip extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;
  const KpiChip({
    super.key,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
        ],
      ),
      constraints: const BoxConstraints(minWidth: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );

    if (onTap != null)
      return Semantics(
        button: true,
        child: InkWell(onTap: onTap, child: child),
      );
    return Semantics(button: false, child: child);
  }
}

class SecondaryCta extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const SecondaryCta({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFFF1F3F6),
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}

class SparklineChart extends StatelessWidget {
  final List<double> a;
  final List<double>? b;
  final Color colorA;
  final Color? colorB;
  const SparklineChart({
    super.key,
    required this.a,
    this.b,
    this.colorA = const Color(0xFF2E6BFF),
    this.colorB,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _SparklinePainter(
            a: a,
            b: b,
            colorA: colorA,
            colorB: colorB,
          ),
        );
      },
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> a;
  final List<double>? b;
  final Color colorA;
  final Color? colorB;
  _SparklinePainter({
    required this.a,
    this.b,
    required this.colorA,
    this.colorB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (a.isEmpty) return;
    final paintA = Paint()
      ..color = colorA
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    final paintB = Paint()
      ..color = colorB ?? const Color(0xFFE53935)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    double maxVal = a.reduce((v, c) => v > c ? v : c);
    if (b != null && b!.isNotEmpty) {
      final maxB = b!.reduce((v, c) => v > c ? v : c);
      maxVal = max(maxVal, maxB);
    }
    if (maxVal == 0) maxVal = 1;

    final step = size.width / (a.length - 1);
    final pathA = Path();
    for (int i = 0; i < a.length; i++) {
      final x = i * step;
      final y = size.height - (a[i] / maxVal) * size.height;
      if (i == 0)
        pathA.moveTo(x, y);
      else
        pathA.lineTo(x, y);
    }
    canvas.drawPath(pathA, paintA);

    if (b != null && b!.isNotEmpty) {
      final stepB = size.width / (b!.length - 1);
      final pathB = Path();
      for (int i = 0; i < b!.length; i++) {
        final x = i * stepB;
        final y = size.height - (b![i] / maxVal) * size.height;
        if (i == 0)
          pathB.moveTo(x, y);
        else
          pathB.lineTo(x, y);
      }
      canvas.drawPath(pathB, paintB);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MicroBarChart extends StatelessWidget {
  final List<int> values;
  final Color color;
  const MicroBarChart({
    super.key,
    required this.values,
    this.color = const Color(0xFF2E6BFF),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _BarPainter(values, color),
        );
      },
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<int> values;
  final Color color;
  _BarPainter(this.values, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final paint = Paint()..color = color;
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final spacingFactor = 2; // bar width : gap = 1 : 1
    final w =
        size.width / (values.length * spacingFactor - (spacingFactor - 1));
    for (int i = 0; i < values.length; i++) {
      final h = (values[i] / (maxV == 0 ? 1 : maxV)) * size.height;
      final x = i * (w * spacingFactor);
      final rect = Rect.fromLTWH(x, size.height - h, w, h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutChart extends StatelessWidget {
  final List<double> values;
  final List<Color>? colors;
  const DonutChart({super.key, required this.values, this.colors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _DonutPainter(values, colors),
        );
      },
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color>? colors;
  _DonutPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final total = values.fold(0.0, (p, e) => p + e);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double start = -pi / 2;
    final stroke = size.shortestSide * 0.28;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / (total == 0 ? 1 : total)) * 2 * pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = colors != null && i < colors!.length
            ? colors![i]
            : Colors.primaries[i % Colors.primaries.length];
      canvas.drawArc(
        rect.deflate(size.shortestSide * 0.14),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
