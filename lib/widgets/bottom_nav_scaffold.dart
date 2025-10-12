import 'package:flutter/material.dart';

class BottomNavScaffold extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final Widget body;

  const BottomNavScaffold({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 8,
          child: SizedBox(
            height: 70,
            child: Row(
              children: [
                _navItem(
                  context,
                  icon: Icons.dashboard,
                  label: 'Beranda',
                  index: 0,
                ),
                _navItem(
                  context,
                  icon: Icons.folder,
                  label: 'Kependudukan',
                  index: 1,
                ),
                // Expanded(child: Container()),
                _navItem(
                  context,
                  icon: Icons.account_balance_wallet,
                  label: 'Keuangan',
                  index: 2,
                ),
                _navItem(
                  context,
                  icon: Icons.show_chart,
                  label: 'Analitik',
                  index: 3,
                ),
                // removed 'Akun' item as requested
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final active = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? const Color(0xFFEAF0FF) : Colors.transparent,
              ),
              child: Icon(
                icon,
                color: active ? const Color(0xFF2E6BFF) : Colors.black45,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? const Color(0xFF2E6BFF) : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
