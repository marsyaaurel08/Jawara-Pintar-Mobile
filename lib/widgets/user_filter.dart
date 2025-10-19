import 'package:flutter/material.dart';

class UserFilter extends StatefulWidget {
  const UserFilter({Key? key}) : super(key: key);

  @override
  State<UserFilter> createState() => _UserFilterState();
}

class _UserFilterState extends State<UserFilter> {
  final _nameCtl = TextEditingController();
  String? _status;

  @override
  void dispose() {
    _nameCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Manajemen Pengguna', style: TextStyle(fontWeight: FontWeight.w700)),
              IconButton(onPressed: () => Navigator.of(context).pop(false), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameCtl,
            decoration: const InputDecoration(labelText: 'Nama', hintText: 'Cari nama...'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _status,
            items: const [
              DropdownMenuItem(value: 'Active', child: Text('Active')),
              DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
            ],
            onChanged: (v) => setState(() => _status = v),
            decoration: const InputDecoration(labelText: 'Status', hintText: '-- Pilih Status --'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Reset Filter')),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Terapkan')),
            ],
          ),
        ],
      ),
    );
  }
}
