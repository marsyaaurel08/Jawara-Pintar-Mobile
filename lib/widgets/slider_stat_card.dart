import 'package:flutter/material.dart';

class SliderStatCard extends StatefulWidget {
  /// item mis. ringkasan: Warga, Rumah, Iuran, Pengeluaran
  final List<_StatSlide> slides;
  const SliderStatCard({super.key, required this.slides});

  @override
  State<SliderStatCard> createState() => _SliderStatCardState();
}

class _SliderStatCardState extends State<SliderStatCard> {
  final _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.slides.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => widget.slides[i],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.slides.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: active ? 18 : 6,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF2E6BFF) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// ====== SLIDE KONTEN SEDERHANA (mock chart / angka ringkasan) ======
class _StatSlide extends StatelessWidget {
  final String title;
  final List<_StatItem> items;
  const _StatSlide({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: items
                  .map(
                    (e) => Expanded(
                      child: _MiniCard(
                        icon: e.icon,
                        label: e.label,
                        value: e.value,
                        color: e.color,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _MiniCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7ECF3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

/// helper static factory (biar gampang dipakai dari luar)
List<_StatSlide> buildDefaultSlides() => [
  _StatSlide(
    title: 'Ringkasan Data',
    items: [
      _StatItem(
        icon: Icons.groups,
        label: 'Warga',
        value: '152',
        color: const Color(0xFF2E6BFF),
      ),
      _StatItem(
        icon: Icons.home_work_outlined,
        label: 'Rumah',
        value: '87',
        color: const Color(0xFF00BFA6),
      ),
      _StatItem(
        icon: Icons.family_restroom,
        label: 'Keluarga',
        value: '96',
        color: const Color(0xFFFFA726),
      ),
    ],
  ),
  _StatSlide(
    title: 'Keuangan Bulan Ini',
    items: [
      _StatItem(
        icon: Icons.arrow_downward,
        label: 'Iuran',
        value: 'Rp 12jt',
        color: const Color(0xFF43A047),
      ),
      _StatItem(
        icon: Icons.arrow_upward,
        label: 'Pengeluaran',
        value: 'Rp 6jt',
        color: const Color(0xFFE53935),
      ),
      _StatItem(
        icon: Icons.receipt_long,
        label: 'Tagihan Aktif',
        value: '34',
        color: const Color(0xFF5C6BC0),
      ),
    ],
  ),
];
