import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile/routes.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({Key? key}) : super(key: key);

  @override
  _PengeluaranPageState createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  final List<Expense> _expenses = [
    Expense(
      id: 'e1',
      title: 'Belanja Harian',
      amount: 45000,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: 'e2',
      title: 'Langganan Internet',
      amount: 120000,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Expense(
      id: 'e3',
      title: 'Transportasi',
      amount: 30000,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Expense(
      id: 'e4',
      title: 'Makan Siang Kantor',
      amount: 25000,
      date: DateTime.now(),
    ),
  ];

  String _formatCurrency(double value) {
    int v = value.round();
    String s = v.toString();
    String res = '';
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      res = s[i] + res;
      count++;
      if (count % 3 == 0 && i != 0) res = '.' + res;
    }
    return 'Rp $res';
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  void _deleteExpense(String id) {
    setState(() => _expenses.removeWhere((e) => e.id == id));
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('Belum ada pengeluaran', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _expenses.length,
      itemBuilder: (ctx, i) {
        final exp = _expenses[i];
        return Dismissible(
          key: ValueKey(exp.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete_forever, color: Colors.white),
          ),
          onDismissed: (_) => _deleteExpense(exp.id),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade100,
              child: Text(exp.title.isNotEmpty ? exp.title[0].toUpperCase() : 'P'),
            ),
            title: Text(exp.title),
            subtitle: Text(_formatDate(exp.date)),
            trailing: SizedBox(
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_formatCurrency(exp.amount),
                      style: const TextStyle(color: Colors.red),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  // placeholder for optional small note if you add it later
                ],
              ),
            ),
            onTap: () {
              // optional: show details
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(exp.title),
                  content: Text('Jumlah: ${_formatCurrency(exp.amount)}\nTanggal: ${_formatDate(exp.date)}'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tutup')),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  double get _total {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: const Text('Total Pengeluaran', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: Text(_formatCurrency(_total), style: const TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ),
          Expanded(child: _expenses.isEmpty ? _buildEmpty() : _buildList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed(Routes.addKeuangan, arguments: 1);
          if (result is Map<String, dynamic> && result['type'] == 'expense') {
            final data = result['data'] as Map<String, dynamic>;
            final newExpense = Expense(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: data['title'] as String,
              amount: (data['amount'] as num).toDouble(),
              date: data['date'] as DateTime,
            );
            setState(() => _expenses.insert(0, newExpense));
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Tambah Pengeluaran',
      ),
    );
  }
}