import 'package:flutter/material.dart';

/// Model untuk data penanggung jawab
class ResponsiblePersonData {
  final String name;
  final int activitiesCount;

  ResponsiblePersonData({required this.name, required this.activitiesCount});
}

/// Bar Chart Horizontal untuk Penanggung Jawab Terbanyak
class ResponsiblePersonBarChart extends StatefulWidget {
  final List<ResponsiblePersonData> data;
  final int maxDisplay;

  const ResponsiblePersonBarChart({
    super.key,
    required this.data,
    this.maxDisplay = 10,
  });

  @override
  State<ResponsiblePersonBarChart> createState() =>
      _ResponsiblePersonBarChartState();
}

class _ResponsiblePersonBarChartState extends State<ResponsiblePersonBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
    if (widget.data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Tidak ada data')),
      );
    }

    // Sort by count and take top maxDisplay
    final sortedData = List<ResponsiblePersonData>.from(widget.data)
      ..sort((a, b) => b.activitiesCount.compareTo(a.activitiesCount));
    final displayData = sortedData.take(widget.maxDisplay).toList();
    final maxCount = displayData.first.activitiesCount;

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFAD1457), Color(0xFFE91E63)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'TOP 10',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Penanggung Jawab ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Column(
                children: displayData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final person = entry.value;
                  final barWidth =
                      (person.activitiesCount / maxCount) * _animation.value;
                  final isHovered = _hoveredIndex == index;

                  return MouseRegion(
                    onEnter: (_) => setState(() => _hoveredIndex = index),
                    onExit: (_) => setState(() => _hoveredIndex = null),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Ranking badge
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _getRankingColors(index),
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getRankingColors(
                                        index,
                                      )[0].withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Name
                              Expanded(
                                child: Text(
                                  person.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isHovered
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isHovered
                                        ? const Color(0xFFAD1457)
                                        : Colors.grey.shade800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Count
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: isHovered ? 15 : 13,
                                  fontWeight: FontWeight.w700,
                                  color: isHovered
                                      ? const Color(0xFFAD1457)
                                      : Colors.grey.shade700,
                                ),
                                child: Text('${person.activitiesCount}'),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'kegiatan',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Bar
                          Stack(
                            children: [
                              // Background bar
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              // Animated bar
                              FractionallySizedBox(
                                widthFactor: barWidth,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: isHovered ? 10 : 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFFAD1457),
                                        const Color(
                                          0xFFAD1457,
                                        ).withOpacity(0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: isHovered
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFAD1457,
                                              ).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Color> _getRankingColors(int index) {
    switch (index) {
      case 0:
        return [const Color(0xFFFFD700), const Color(0xFFFFAA00)]; // Gold
      case 1:
        return [const Color(0xFFC0C0C0), const Color(0xFF808080)]; // Silver
      case 2:
        return [const Color(0xFFCD7F32), const Color(0xFF8B4513)]; // Bronze
      default:
        return [const Color(0xFFAD1457), const Color(0xFFE91E63)]; // Pink
    }
  }
}
