import 'package:flutter/material.dart';

/// KPI Cards untuk Kegiatan Berdasarkan Waktu
/// Menampilkan: Sudah Lewat, Hari Ini, Akan Datang
class TimeBasedKpiCards extends StatelessWidget {
  final int pastActivities;
  final int todayActivities;
  final int upcomingActivities;

  const TimeBasedKpiCards({
    super.key,
    required this.pastActivities,
    required this.todayActivities,
    required this.upcomingActivities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, color: Colors.red.shade700, size: 20),
            const SizedBox(width: 8),
            Text(
              'Kegiatan berdasarkan Waktu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTimeCard(
          label: 'Sudah Lewat',
          value: pastActivities,
          icon: Icons.history,
          backgroundColor: const Color(0xFFFCE4EC),
          iconColor: const Color(0xFFE91E63),
          valueColor: const Color(0xFFAD1457),
        ),
        const SizedBox(height: 12),
        _buildTimeCard(
          label: 'Hari Ini',
          value: todayActivities,
          icon: Icons.today,
          backgroundColor: const Color(0xFFE3F2FD),
          iconColor: const Color(0xFF2196F3),
          valueColor: const Color(0xFF1565C0),
        ),
        const SizedBox(height: 12),
        _buildTimeCard(
          label: 'Akan Datang',
          value: upcomingActivities,
          icon: Icons.event_available,
          backgroundColor: const Color(0xFFFFF3E0),
          iconColor: const Color(0xFFFF9800),
          valueColor: const Color(0xFFE65100),
        ),
      ],
    );
  }

  Widget _buildTimeCard({
    required String label,
    required int value,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: iconColor.withOpacity(0.2), size: 32),
        ],
      ),
    );
  }
}
