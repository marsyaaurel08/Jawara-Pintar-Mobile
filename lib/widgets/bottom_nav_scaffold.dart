import 'package:flutter/material.dart';

class BottomNavScaffold extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final Widget body;

  const BottomNavScaffold({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a clean white background for the nav and a subtle shadow
    final bgColor = Colors.white;
    final primary = const Color.fromARGB(
      255,
      5,
      117,
      209,
    ); // Example primary color

    return Scaffold(
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 78,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _flatNavItem(
                  context,
                  icon: Icons.home_outlined,
                  label: 'Beranda',
                  index: 0,
                  activeColor: primary,
                ),
                _flatNavItem(
                  context,
                  icon: Icons.menu_book_outlined,
                  label: 'Kependudukan',
                  index: 1,
                  activeColor: primary,
                  labelWidth: 96,
                ),
                _flatNavItem(
                  context,
                  icon: Icons.schedule_outlined,
                  label: 'Keuangan',
                  index: 2,
                  activeColor: primary,
                ),
                _flatNavItem(
                  context,
                  icon: Icons.event_outlined,
                  label: 'Analitik',
                  index: 3,
                  activeColor: primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // removed legacy _navItem to avoid unused declaration

  Widget _flatNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required Color activeColor,
    double? labelWidth,
  }) {
    final active = index == currentIndex;
    final theme = Theme.of(context);
    final inactiveColor =
        theme.textTheme.bodySmall?.color?.withOpacity(0.75) ?? Colors.black54;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(active ? 8 : 6),
            decoration: BoxDecoration(
              color: active
                  ? activeColor.withOpacity(0.08)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: active ? activeColor : inactiveColor,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: labelWidth ?? 72,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: active ? 12 : 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? activeColor : inactiveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // no additional helpers required
}
