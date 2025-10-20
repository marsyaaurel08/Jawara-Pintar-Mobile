import 'package:flutter/material.dart';
import 'dart:math';

// Clean, single implementation of the laporan page.
class TransactionItem {
  final DateTime date;
  final String category;
  final String note;
  final double amount; // positive = income, negative = expense

  TransactionItem({
    required this.date,
    required this.category,
    required this.note,
    required this.amount,
  });
}

class LaporanPage extends StatelessWidget {
  const LaporanPage({Key? key}) : super(key: key);

  String _shortMonth(int m) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[m];
  }

  int _monthFromShort(String s) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    return months[s] ?? 1;
  }

  String _formatCurrency(double value) {
    final sign = value < 0 ? '-' : '';
    final absVal = value.abs().round();
    final s = absVal.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buffer.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write(',');
    }
    return "$sign${buffer.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    final transactions = <TransactionItem>[
      TransactionItem(date: DateTime(2025, 1, 5), category: 'Penjualan', note: 'Order #1001', amount: 1250000),
      TransactionItem(date: DateTime(2025, 1, 8), category: 'Operasional', note: 'Sewa tempat', amount: -350000),
      TransactionItem(date: DateTime(2025, 2, 3), category: 'Penjualan', note: 'Order #1023', amount: 980000),
      TransactionItem(date: DateTime(2025, 2, 10), category: 'Gaji', note: 'Karyawan bulan Feb', amount: -450000),
      TransactionItem(date: DateTime(2025, 3, 2), category: 'Penjualan', note: 'Order #1070', amount: 1750000),
      TransactionItem(date: DateTime(2025, 3, 20), category: 'Operasional', note: 'Listrik & Internet', amount: -120000),
      TransactionItem(date: DateTime(2025, 4, 15), category: 'Investasi', note: 'Top up alat', amount: -600000),
      TransactionItem(date: DateTime(2025, 4, 28), category: 'Penjualan', note: 'Event promo', amount: 860000),
      TransactionItem(date: DateTime(2025, 5, 5), category: 'Penjualan', note: 'Order #1150', amount: 940000),
      TransactionItem(date: DateTime(2025, 5, 18), category: 'Gaji', note: 'Bonus karyawan', amount: -220000),
      TransactionItem(date: DateTime(2025, 6, 1), category: 'Penjualan', note: 'Order #1200', amount: 1320000),
      TransactionItem(date: DateTime(2025, 6, 12), category: 'Operasional', note: 'Maintenance', amount: -180000),
    ];

    double totalIncome() => transactions.where((t) => t.amount > 0).fold(0.0, (s, t) => s + t.amount);
    double totalExpense() => transactions.where((t) => t.amount < 0).fold(0.0, (s, t) => s + t.amount.abs());

    Map<String, Map<String, double>> monthlyAggregate() {
      final map = <String, Map<String, double>>{};
      for (var t in transactions) {
        final key = '${_shortMonth(t.date.month)} ${t.date.year}';
        map.putIfAbsent(key, () => {'income': 0.0, 'expense': 0.0});
        if (t.amount >= 0) {
          map[key]!['income'] = map[key]!['income']! + t.amount;
        } else {
          map[key]!['expense'] = map[key]!['expense']! + t.amount.abs();
        }
      }
      final sortedKeys = map.keys.toList()
        ..sort((a, b) {
          final aParts = a.split(' ');
          final bParts = b.split(' ');
          final aMonth = _monthFromShort(aParts[0]);
          final bMonth = _monthFromShort(bParts[0]);
          final aYear = int.parse(aParts[1]);
          final bYear = int.parse(bParts[1]);
          final aDate = DateTime(aYear, aMonth);
          final bDate = DateTime(bYear, bMonth);
          return aDate.compareTo(bDate);
        });
      return {for (var k in sortedKeys) k: map[k]!};
    }

    final income = totalIncome();
    final expense = totalExpense();
    final net = income - expense;
    final monthly = monthlyAggregate();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 5, 117, 209),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 117, 209),
                  Color.fromARGB(255, 3, 95, 170),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Laporan Keuangan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                _summaryCard('Total Pemasukan', 'Rp ${_formatCurrency(income)}', Colors.green.withOpacity(0.1), Colors.green),
                const SizedBox(width: 8),
                _summaryCard('Total Pengeluaran', 'Rp ${_formatCurrency(expense)}', Colors.red.withOpacity(0.07), Colors.red),
                const SizedBox(width: 8),
                _summaryCard('Saldo Bersih', 'Rp ${_formatCurrency(net)}', Colors.blue.withOpacity(0.07), net >= 0 ? Colors.blue : Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            _buildMonthlyChart(monthly),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transaksi Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${transactions.length} items', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: t.amount >= 0 ? Colors.green[100] : Colors.red[100],
                      child: Icon(
                        t.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
                        color: t.amount >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(t.category),
                    subtitle: Text('${t.note} • ${t.date.day}/${t.date.month}/${t.date.year}'),
                    trailing: Text(
                      (t.amount >= 0 ? 'Rp ${_formatCurrency(t.amount)}' : '- Rp ${_formatCurrency(t.amount.abs())}'),
                      style: TextStyle(
                        color: t.amount >= 0 ? Colors.green[700] : Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String value, Color bg, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accent.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart(Map<String, Map<String, double>> monthly) {
    if (monthly.isEmpty) return const SizedBox.shrink();

    final maxVal = monthly.values.map((v) => v['income']! + v['expense']!).fold<double>(0.0, (p, v) => max(p, v)) + 1.0;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Ringkasan Bulanan', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(child: Text('Perbandingan pemasukan (hijau) & pengeluaran (merah)', style: TextStyle(color: Colors.grey[600], fontSize: 12))),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthly.entries.map((entry) {
                final inc = entry.value['income']!;
                final exp = entry.value['expense']!;
                final incH = (inc / maxVal) * 140;
                final expH = (exp / maxVal) * 140;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(width: 22, height: incH, decoration: BoxDecoration(color: Colors.green[400], borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))),
                      Container(width: 22, height: expH, decoration: BoxDecoration(color: Colors.red[400], borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)))),
                      const SizedBox(height: 6),
                      Text(entry.key, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 6),
                      Text('Rp ${_formatCurrency(inc)}', style: TextStyle(fontSize: 10, color: Colors.green[800])),
                      Text('- Rp ${_formatCurrency(exp)}', style: TextStyle(fontSize: 10, color: Colors.red[800])),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}