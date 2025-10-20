import 'package:flutter/material.dart';
import '../../pages/analytics_page.dart';

/// SliderStatCard: compact analytics preview used on the Home page.
class SliderStatCard extends StatefulWidget {
  final void Function(int index)? onViewAnalytics;
  const SliderStatCard({Key? key, this.onViewAnalytics}) : super(key: key);

  @override
  State<SliderStatCard> createState() => _SliderStatCardState();
}

class _SliderStatCardState extends State<SliderStatCard> {
  // Sedikit mengintip slide berikutnya agar terasa "carousel"
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _index = 0;

  static const List<_SlideData> _slides = [
    _SlideData(
      title: 'Keuangan',
      items: [
        _SlideItem(
          label: 'Pemasukan',
          value: 'Rp 12.345',
          icon: Icons.trending_up,
          color: Color(0xFF2E7D32),
        ),
        _SlideItem(
          label: 'Pengeluaran',
          value: 'Rp 4.321',
          icon: Icons.trending_down,
          color: Color(0xFFC62828),
        ),
        _SlideItem(
          label: 'Saldo',
          value: 'Rp 8.024',
          icon: Icons.account_balance_wallet,
          color: Color(0xFF1565C0),
        ),
      ],
    ),
    _SlideData(
      title: 'Kegiatan',
      items: [
        _SlideItem(
          label: 'Kegiatan',
          value: '24',
          icon: Icons.event_available,
          color: Color(0xFFAD1457),
        ),
        _SlideItem(
          label: 'Partisipan',
          value: '1.234',
          icon: Icons.people_alt,
          color: Color(0xFF6A1B9A),
        ),
        _SlideItem(
          label: 'Rata-rata',
          value: '51%',
          icon: Icons.insights,
          color: Color(0xFF0288D1),
        ),
      ],
    ),
    _SlideData(
      title: 'Kependudukan',
      items: [
        _SlideItem(
          label: 'Warga',
          value: '5.678',
          icon: Icons.person,
          color: Color(0xFF2E7D32),
        ),
        _SlideItem(
          label: 'Kelurahan',
          value: '12',
          icon: Icons.map,
          color: Color(0xFFEF6C00),
        ),
        _SlideItem(
          label: 'Kepala Keluarga',
          value: '1.234',
          icon: Icons.family_restroom,
          color: Color(0xFF6D4C41),
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleViewDetail(int tabIndex) {
    if (widget.onViewAnalytics != null) {
      widget.onViewAnalytics!(tabIndex);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AnalyticsPage(initialTab: tabIndex)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 215,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -- PAGEVIEW --------------------------------------------------------
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final slide = _slides[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row: judul + tombol detail
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                child: Text(
                                  slide.title,
                                  key: ValueKey(slide.title),
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => _handleViewDetail(i),
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: cs.primary,
                                  size: 18,
                                ),
                                label: Text(
                                  'Lihat Detail',
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Isi: 3 mini stat card
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: slide.items
                                  .map(
                                    (it) => Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                        ),
                                        child: _MiniStatCard(item: it),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // -- INDICATOR DOTS --------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: active ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? cs.primary : cs.outlineVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final _SlideItem item;
  const _MiniStatCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isDark
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
        border: Border.all(
          color: isDark
              ? cs.outlineVariant
              : const Color.fromARGB(255, 222, 221, 221),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          CircleAvatar(
            radius: 20,
            backgroundColor: item.color.withOpacity(isDark ? 0.12 : 0.10),
            child: Icon(item.icon, color: item.color, size: 18),
          ),
          const SizedBox(height: 8),
          // Nilai (primary)
          Text(
            item.value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          // Label kecil
          Text(
            item.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.black54.withOpacity(isDark ? 0.7 : 1),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  final String title;
  final List<_SlideItem> items;
  const _SlideData({required this.title, required this.items});
}

class _SlideItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _SlideItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
