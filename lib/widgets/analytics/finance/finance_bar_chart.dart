import 'package:flutter/material.dart';
import '../../../models/analytics/finance_summary.dart';

/// Finance Bar Chart untuk Analytics Keuangan
class FinanceBarChart extends StatefulWidget {
  final String title;
  final List<MonthlyFinance> monthlyData;
  final Color barColor;
  final String label;
  final bool isIncome;

  const FinanceBarChart({
    super.key,
    required this.title,
    required this.monthlyData,
    required this.barColor,
    required this.label,
    this.isIncome = true,
  });

  @override
  State<FinanceBarChart> createState() => _FinanceBarChartState();
}

class _FinanceBarChartState extends State<FinanceBarChart>
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
      curve: Curves.easeOutCubic,
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
    if (widget.monthlyData.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text('Tidak ada data')),
      );
    }

    final values = widget.monthlyData
        .map((e) => widget.isIncome ? e.income : e.expense)
        .toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);

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
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: widget.monthlyData.length * 85.0,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.monthlyData.length * 85.0, 250),
                      painter: _FinanceBarPainter(
                        data: widget.monthlyData,
                        maxValue: maxValue,
                        progress: _animation.value,
                        hoveredIndex: _hoveredIndex,
                        barColor: widget.barColor,
                        isIncome: widget.isIncome,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: widget.monthlyData.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          return Expanded(
                            child: MouseRegion(
                              onEnter: (_) =>
                                  setState(() => _hoveredIndex = index),
                              onExit: (_) =>
                                  setState(() => _hoveredIndex = null),
                              child: const SizedBox(height: 250),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceBarPainter extends CustomPainter {
  final List<MonthlyFinance> data;
  final double maxValue;
  final double progress;
  final int? hoveredIndex;
  final Color barColor;
  final bool isIncome;

  _FinanceBarPainter({
    required this.data,
    required this.maxValue,
    required this.progress,
    this.hoveredIndex,
    required this.barColor,
    required this.isIncome,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 45.0;
    final spacing = (size.width - (data.length * barWidth)) / (data.length + 1);
    final chartHeight = size.height - 40; // Leave space for labels

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = (chartHeight / 5) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final value = isIncome ? item.income : item.expense;
      final x = spacing + (i * (barWidth + spacing));
      final barHeight = (value / maxValue) * (chartHeight - 50) * progress;
      final y = chartHeight - 30 - barHeight;
      final isHovered = hoveredIndex == i;

      // Bar shadow
      final shadowPaint = Paint()
        ..color = barColor.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final shadowRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 2, y + 2, barWidth, barHeight),
        const Radius.circular(8),
      );
      canvas.drawRRect(shadowRect, shadowPaint);

      // Bar gradient
      final barRect = Rect.fromLTWH(x, y, barWidth, barHeight);
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [barColor, barColor.withOpacity(0.7)],
      );

      final barPaint = Paint()
        ..shader = gradient.createShader(barRect)
        ..style = PaintingStyle.fill;

      final barRRect = RRect.fromRectAndRadius(
        isHovered ? Rect.fromLTWH(x - 2, y, barWidth + 4, barHeight) : barRect,
        const Radius.circular(8),
      );

      canvas.drawRRect(barRRect, barPaint);

      // Value label
      if (progress > 0.5) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: _formatValue(value),
            style: TextStyle(
              fontSize: isHovered ? 14 : 12,
              fontWeight: FontWeight.w700,
              color: barColor,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + (barWidth - textPainter.width) / 2, y - 20),
        );
      }

      // Month label
      final monthPainter = TextPainter(
        text: TextSpan(
          text: item.month,
          style: TextStyle(
            fontSize: 11,
            color: isHovered ? barColor : Colors.grey.shade600,
            fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      monthPainter.layout();
      monthPainter.paint(
        canvas,
        Offset(x + (barWidth - monthPainter.width) / 2, chartHeight - 20),
      );
    }
  }

  String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(_FinanceBarPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      hoveredIndex != oldDelegate.hoveredIndex;
}
