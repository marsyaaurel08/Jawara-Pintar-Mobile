import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile/models/feature_item.dart';

class SearchPage extends StatefulWidget {
  final List<FeatureItem> features;
  const SearchPage({super.key, required this.features});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _ctrl = TextEditingController();
  List<FeatureItem> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered = widget.features;
    _ctrl.addListener(_onChange);
  }

  void _onChange() {
    final q = _ctrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        filtered = widget.features;
      } else {
        filtered = widget.features
            .where((f) => f.title.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onChange);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _ctrl.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari Fitur',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: hasQuery
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _ctrl.clear(),
                  )
                : null,
          ),
        ),
        backgroundColor: const Color(0xFF2E6BFF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            if (filtered.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Tidak menemukan yang kamu cari?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E6BFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Periksa ulang kata kunci untuk kesalahan ketik atau ganti kata kunci',
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final f = filtered[i];
                    return ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: f.bg.withOpacity(.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(f.icon, color: f.bg),
                      ),
                      title: Text(f.title),
                      onTap: () {
                        Navigator.pop(context);
                        f.onTap();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
