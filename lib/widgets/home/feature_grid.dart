import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile/models/feature_item.dart';

class FeatureGrid extends StatefulWidget {
  final List<FeatureItem> items;
  const FeatureGrid({super.key, required this.items});

  @override
  State<FeatureGrid> createState() => _FeatureGridState();
}

class _FeatureGridState extends State<FeatureGrid> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final shown = expanded ? widget.items : widget.items.take(8).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: shown.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (_, i) => _FeatureIcon(item: shown[i]),
          ),
          const SizedBox(height: 8),
          // subtle divider above the "Lainnya" button (reference style)
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey.shade200,
          ),
          TextButton(
            onPressed: () => setState(() => expanded = !expanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(expanded ? 'Tutup' : 'Lainnya'),
                const SizedBox(width: 4),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final FeatureItem item;
  const _FeatureIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: item.bg.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.icon,
              color: item.bg,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
