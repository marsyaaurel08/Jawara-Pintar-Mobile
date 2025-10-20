import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Model untuk data pie chart keuangan
class PieChartData {
  final String label;
  final double value;
  final double percentage;
  final Color color;

  PieChartData({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });
}

/// Finance Pie Chart untuk Analytics Keuangan
class FinancePieChart extends StatefulWidget {
  final String title;
  final List<PieChartData> data;
  final String centerLabel;

  const FinancePieChart({
    super.key,
    required this.title,
    required this.data,
    this.centerLabel = 'Total',
  });

  @override
  State<FinancePieChart> createState() => _FinancePieChartState();
}

class _FinancePieChartState extends State<FinancePieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const SizedBox(
          height: 200,
          child: Center(child: Text('Tidak ada data')),
        ),
      );
    }

    final totalValue = widget.data.fold<double>(
      0,
      (sum, item) => sum + item.value,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(220, 220),
                  painter: _FinancePiePainter(
                    data: widget.data,
                    progress: _animation.value,
                    hoveredIndex: _hoveredIndex,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.centerLabel,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatValue(totalValue),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  String _formatValue(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  Widget _buildLegend() {
    return Column(
      children: widget.data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isHovered = _hoveredIndex == index;

        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() => _hoveredIndex = null),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isHovered
                  ? item.color.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isHovered ? 16 : 14,
                  height: isHovered ? 16 : 14,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: item.color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                      color: isHovered ? item.color : Colors.grey.shade800,
                    ),
                  ),
                ),
                Text(
                  '${_formatValue(item.value)} ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '(${item.percentage.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isHovered ? item.color : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FinancePiePainter extends CustomPainter {
  final List<PieChartData> data;
  final double progress;
  final int? hoveredIndex;

  _FinancePiePainter({
    required this.data,
    required this.progress,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final innerRadius = radius * 0.6;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.percentage / 100) * 2 * math.pi * progress;
      final isHovered = hoveredIndex == i;
      final currentRadius = isHovered ? radius + 6 : radius;

      final paint = Paint()
        ..shader = LinearGradient(
          colors: [item.color, item.color.withOpacity(0.7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromCircle(center: center, radius: currentRadius))
        ..style = PaintingStyle.fill;

      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: currentRadius),
        startAngle,
        sweepAngle,
        false,
      );
      path.close();

      canvas.drawPath(path, paint);

      final innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, innerRadius, innerPaint);

      if (i < data.length - 1) {
        final separatorPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        final angle = startAngle + sweepAngle;
        final x1 = center.dx + innerRadius * math.cos(angle);
        final y1 = center.dy + innerRadius * math.sin(angle);
        final x2 = center.dx + currentRadius * math.cos(angle);
        final y2 = center.dy + currentRadius * math.sin(angle);

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), separatorPaint);
      }

      if (isHovered) {
        final shadowPaint = Paint()
          ..color = item.color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawPath(path, shadowPaint);
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_FinancePiePainter oldDelegate) =>
      progress != oldDelegate.progress ||
      hoveredIndex != oldDelegate.hoveredIndex;
}
