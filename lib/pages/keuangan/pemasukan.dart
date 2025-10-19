import 'package:flutter/material.dart';

class Income {
  String title;
  double amount;
  DateTime date;
  String category;
  String note;

  Income({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.note,
  });
}

class PemasukanPage extends StatefulWidget {
  const PemasukanPage({Key? key}) : super(key: key);

  @override
  _PemasukanPageState createState() => _PemasukanPageState();
}

class _PemasukanPageState extends State<PemasukanPage> {
  // EMPTY THIS IF NO DUMMY
final List<Income> _incomes = [
  Income(
    title: 'Gaji Bulanan',
    amount: 5000000,
    date: DateTime.now().subtract(const Duration(days: 5)),
    category: 'Gaji',
    note: 'Gaji dari kantor',
  ),
  Income(
    title: 'Bonus Proyek Sampingan',
    amount: 1500000,
    date: DateTime.now().subtract(const Duration(days: 2)),
    category: 'Bonus',
    note: '', // Catatan kosong
  ),
  Income(
    title: 'Uang Jajan dari Ortu',
    amount: 250000,
    date: DateTime.now(),
    category: 'Hadiah',
    note: 'Buat beli buku',
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

  double get _total =>
      _incomes.fold(0.0, (previousValue, element) => previousValue + element.amount);

  Future<void> _showForm({Income? income}) async {
    final isEditing = income != null;
    final titleCtrl = TextEditingController(text: income?.title ?? '');
    final amountCtrl =
        TextEditingController(text: income != null ? income.amount.toString() : '');
    final categoryCtrl = TextEditingController(text: income?.category ?? '');
    final noteCtrl = TextEditingController(text: income?.note ?? '');
    DateTime selectedDate = income?.date ?? DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: StatefulBuilder(builder: (ctx, setModalState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isEditing ? 'Edit Pemasukan' : 'Tambah Pemasukan',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Judul'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: categoryCtrl,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteCtrl,
                    decoration: const InputDecoration(labelText: 'Catatan (opsional)'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Text('Tanggal: ${_formatDate(selectedDate)}')),
                      TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setModalState(() => selectedDate = picked);
                            }
                          },
                          child: const Text('Pilih tanggal'))
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final title = titleCtrl.text.trim();
                          final amount = double.tryParse(amountCtrl.text.replaceAll(',', '').replaceAll('.', '')) ??
                              double.tryParse(amountCtrl.text) ??
                              0.0;
                          final category = categoryCtrl.text.trim();

                          if (title.isEmpty || amount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Isi judul dan jumlah yang valid')));
                            return;
                          }

                          if (isEditing) {
                            setState(() {
                              income.title = title;
                              income.amount = amount;
                              income.date = selectedDate;
                              income.category = category;
                              income.note = noteCtrl.text.trim();
                            });
                          } else {
                            final newIncome = Income(
                              title: title,
                              amount: amount,
                              date: selectedDate,
                              category: category,
                              note: noteCtrl.text.trim(),
                            );
                            setState(() => _incomes.insert(0, newIncome));
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(isEditing ? 'Simpan' : 'Tambah'),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  void _deleteIncomeAt(int idx) {
    if (idx < 0 || idx >= _incomes.length) return;
    final removed = _incomes.removeAt(idx);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Pemasukan dihapus'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() => _incomes.insert(idx, removed));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemasukan'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: const Text('Total Pemasukan', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: Text(_formatCurrency(_total), style: const TextStyle(fontSize: 16, color: Colors.green)),
            ),
          ),
          Expanded(
            child: _incomes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wallet, size: 64, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text('Belum ada data pemasukan', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: _incomes.length,
                    itemBuilder: (ctx, i) {
                      final inc = _incomes[i];
                      return Dismissible(
                        key: ObjectKey(inc),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete_forever, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteIncomeAt(i),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Text(inc.category.isNotEmpty ? inc.category[0].toUpperCase() : 'P'),
                          ),
                          title: Text(inc.title),
                          subtitle: Text('${_formatDate(inc.date)} • ${inc.category.isNotEmpty ? inc.category : 'Umum'}'),
                          trailing: SizedBox(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(_formatCurrency(inc.amount),
                                    style: const TextStyle(color: Colors.green),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                if (inc.note.isNotEmpty)
                                  Text(inc.note,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          onTap: () => _showForm(income: inc),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
        tooltip: 'Tambah Pemasukan',
      ),
    );
  }
}
