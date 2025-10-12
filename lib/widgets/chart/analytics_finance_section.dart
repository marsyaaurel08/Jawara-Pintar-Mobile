import 'package:flutter/material.dart';
import 'analytics_finance_chart.dart';
import 'analytics_pie_chart.dart';

class AnalyticsFinanceSection extends StatelessWidget {
  const AnalyticsFinanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    // dummy values
    final pemasukan = 100000000; // Rp 100.000.000
    final pengeluaran = 70000000; // Rp 70.000.000

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // three uniform stat cards: Transaksi, Pemasukan, Pengeluaran
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final stats = [
              {
                'label': 'Jumlah Transaksi',
                'value': '4',
                'icon': Icons.receipt_long,
                'color': Colors.indigo,
              },
              {
                'label': 'Total Pemasukan',
                'value': 'Rp ${_formatCurrency(pemasukan)}',
                'icon': Icons.arrow_downward,
                'color': Colors.green,
              },
              {
                'label': 'Total Pengeluaran',
                'value': 'Rp ${_formatCurrency(pengeluaran)}',
                'icon': Icons.arrow_upward,
                'color': Colors.redAccent,
              },
            ];

            if (isWide) {
              return Row(
                children: stats.map((s) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _StatCard(
                        label: s['label'] as String,
                        value: s['value'] as String,
                        icon: s['icon'] as IconData,
                        color: s['color'] as Color,
                      ),
                    ),
                  );
                }).toList(),
              );
            }

            return Column(
              children: stats.map((s) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _StatCard(
                    label: s['label'] as String,
                    value: s['value'] as String,
                    icon: s['icon'] as IconData,
                    color: s['color'] as Color,
                  ),
                );
              }).toList(),
            );
          },
        ),

        const SizedBox(height: 16),

        // charts: finance bars
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text(
                  'Pemasukan per Bulan',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12),
                AnalyticsFinanceChart(
                  barColor: Colors.green,
                  data: [20, 50, 40, 60, 80, 95],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text(
                  'Pengeluaran per Bulan',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12),
                AnalyticsFinanceChart(
                  barColor: Colors.blue,
                  data: [30, 45, 35, 55, 60, 85],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // category pie charts — responsive: side-by-side on wide screens, stacked on narrow
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final incomeData = {
              'Iuran': 40.0,
              'Donasi': 25.0,
              'Penjualan': 20.0,
              'Lainnya': 15.0,
            };
            final expenseData = {
              'Operasional': 45.0,
              'Gaji': 30.0,
              'Perlengkapan': 15.0,
              'Lainnya': 10.0,
            };

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Pemasukan Berdasarkan Kategori',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            AnalyticsPieChart(data: incomeData),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Pengeluaran Berdasarkan Kategori',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            AnalyticsPieChart(data: expenseData),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            // stacked
            return Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Pemasukan Berdasarkan Kategori',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        AnalyticsPieChart(data: incomeData),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Pengeluaran Berdasarkan Kategori',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        AnalyticsPieChart(data: expenseData),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _formatCurrency(int v) {
    final jt = (v / 1000000).round();
    return '$jt Jt';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
