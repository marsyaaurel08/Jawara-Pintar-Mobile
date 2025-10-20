import 'package:flutter/material.dart';

class AddKeuanganPage extends StatefulWidget {
	final int initialIndex;
	const AddKeuanganPage({Key? key, this.initialIndex = 0}) : super(key: key);

	@override
	_AddKeuanganPageState createState() => _AddKeuanganPageState();
}

class _AddKeuanganPageState extends State<AddKeuanganPage> {
	@override
	Widget build(BuildContext context) {
			return DefaultTabController(
				length: 2,
				initialIndex: widget.initialIndex,
				child: Scaffold(
				appBar: AppBar(
					title: const Text('Tambah Keuangan'),
					bottom: const TabBar(
						tabs: [
							Tab(text: 'Pemasukan'),
							Tab(text: 'Pengeluaran'),
						],
					),
				),
				body: TabBarView(
					children: [
						_AddIncomeTab(onSubmit: (map) => Navigator.of(context).pop({'type': 'income', 'data': map})),
						_AddExpenseTab(onSubmit: (map) => Navigator.of(context).pop({'type': 'expense', 'data': map})),
					],
				),
			),
		);
	}
}

class _AddIncomeTab extends StatefulWidget {
	final void Function(Map<String, dynamic>) onSubmit;
	const _AddIncomeTab({Key? key, required this.onSubmit}) : super(key: key);

	@override
	State<_AddIncomeTab> createState() => _AddIncomeTabState();
}

class _AddIncomeTabState extends State<_AddIncomeTab> {
	final _titleCtrl = TextEditingController();
	final _amountCtrl = TextEditingController();
	final _categoryCtrl = TextEditingController();
	final _noteCtrl = TextEditingController();
	DateTime _selectedDate = DateTime.now();

	@override
	void dispose() {
		_titleCtrl.dispose();
		_amountCtrl.dispose();
		_categoryCtrl.dispose();
		_noteCtrl.dispose();
		super.dispose();
	}

	void _submit() {
		final title = _titleCtrl.text.trim();
		final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.')) ?? 0.0;
		final category = _categoryCtrl.text.trim();
		final note = _noteCtrl.text.trim();

		if (title.isEmpty || amount <= 0) {
			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi judul dan jumlah yang valid')));
			return;
		}

		widget.onSubmit({
			'title': title,
			'amount': amount,
			'date': _selectedDate,
			'category': category,
			'note': note,
		});
	}

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			padding: const EdgeInsets.all(16),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul')),
					const SizedBox(height: 8),
					TextField(controller: _amountCtrl, decoration: const InputDecoration(labelText: 'Jumlah'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
					const SizedBox(height: 8),
					TextField(controller: _categoryCtrl, decoration: const InputDecoration(labelText: 'Kategori')),
					const SizedBox(height: 8),
					TextField(controller: _noteCtrl, decoration: const InputDecoration(labelText: 'Catatan (opsional)')),
					const SizedBox(height: 12),
					Row(
						children: [
							Expanded(child: Text('Tanggal: ${_selectedDate.toLocal().toString().split(' ')[0]}')),
							TextButton(onPressed: () async {
								final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
								if (picked != null) setState(() => _selectedDate = picked);
							}, child: const Text('Pilih Tanggal')),
						],
					),
					const SizedBox(height: 12),
					ElevatedButton(onPressed: _submit, child: const Text('Simpan')),
				],
			),
		);
	}
}

class _AddExpenseTab extends StatefulWidget {
	final void Function(Map<String, dynamic>) onSubmit;
	const _AddExpenseTab({Key? key, required this.onSubmit}) : super(key: key);

	@override
	State<_AddExpenseTab> createState() => _AddExpenseTabState();
}

class _AddExpenseTabState extends State<_AddExpenseTab> {
	final _titleCtrl = TextEditingController();
	final _amountCtrl = TextEditingController();
	DateTime _selectedDate = DateTime.now();

	@override
	void dispose() {
		_titleCtrl.dispose();
		_amountCtrl.dispose();
		super.dispose();
	}

	void _submit() {
		final title = _titleCtrl.text.trim();
		final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.')) ?? -1;
		if (title.isEmpty || amount <= 0) {
			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan judul dan jumlah yang valid')));
			return;
		}
		widget.onSubmit({
			'title': title,
			'amount': amount,
			'date': _selectedDate,
		});
	}

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			padding: const EdgeInsets.all(16),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul')),
					const SizedBox(height: 8),
					TextField(controller: _amountCtrl, decoration: const InputDecoration(labelText: 'Jumlah'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
					const SizedBox(height: 8),
					Row(
						children: [
							Expanded(child: Text('Tanggal: ${_selectedDate.toLocal().toString().split(' ')[0]}')),
							TextButton(onPressed: () async {
								final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
								if (picked != null) setState(() => _selectedDate = picked);
							}, child: const Text('Pilih Tanggal')),
						],
					),
					const SizedBox(height: 12),
					ElevatedButton(onPressed: _submit, child: const Text('Simpan')),
				],
			),
		);
	}
}

