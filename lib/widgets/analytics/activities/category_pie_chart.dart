import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Model untuk data pie chart kategori kegiatan
class CategoryPieData {
  final String category;
  final int count;
  final double percentage;
  final Color color;

  CategoryPieData({
    required this.category,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

/// Professional Pie Chart untuk Kategori Kegiatan
class CategoryPieChart extends StatefulWidget {
  final List<CategoryPieData> categories;

  const CategoryPieChart({super.key, required this.categories});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart>
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
    if (widget.categories.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Tidak ada data')),
      );
    }

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
        children: [
          // Pie Chart
          SizedBox(
            height: 240,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(240, 240),
                  painter: _CategoryPiePainter(
                    categories: widget.categories,
                    progress: _animation.value,
                    hoveredIndex: _hoveredIndex,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.categories.fold<int>(0, (sum, item) => sum + item.count)}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFAD1457),
                          ),
                        ),
                        Text(
                          'Kegiatan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: widget.categories.asMap().entries.map((entry) {
        final index = entry.key;
        final cat = entry.value;
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
                  ? cat.color.withOpacity(0.1)
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
                    color: cat.color,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: cat.color.withOpacity(0.4),
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
                    cat.category,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                      color: isHovered ? cat.color : Colors.grey.shade800,
                    ),
                  ),
                ),
                Text(
                  '${cat.count} ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '(${cat.percentage.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isHovered ? cat.color : Colors.grey.shade700,
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

class _CategoryPiePainter extends CustomPainter {
  final List<CategoryPieData> categories;
  final double progress;
  final int? hoveredIndex;

  _CategoryPiePainter({
    required this.categories,
    required this.progress,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final innerRadius = radius * 0.6;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final sweepAngle = (cat.percentage / 100) * 2 * math.pi * progress;
      final isHovered = hoveredIndex == i;
      final currentRadius = isHovered ? radius + 8 : radius;

      // Draw segment
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [cat.color, cat.color.withOpacity(0.7)],
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

      // Draw inner circle (donut hole)
      final innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, innerRadius, innerPaint);

      // Draw white separator
      if (i < categories.length - 1) {
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

      // Add shadow for hovered segment
      if (isHovered) {
        final shadowPaint = Paint()
          ..color = cat.color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawPath(path, shadowPaint);
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_CategoryPiePainter oldDelegate) =>
      progress != oldDelegate.progress ||
      hoveredIndex != oldDelegate.hoveredIndex;
}
