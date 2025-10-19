import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  // Backwards-compatible fields: older code used `greeting` and `subtitle`.
  final String? greeting;
  final String? subtitle;

  // New fields preferred by updated UI
  final String? title;
  final String? name;

  final VoidCallback? onNotification;

  const DashboardHeader({
    super.key,
    // old
    this.greeting,
    this.subtitle,
    // new
    this.title,
    this.name,
    this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.black87;
    // Choose display values (prefer new fields, fallback to old ones)
    final displayTitle = title ?? greeting ?? 'Selamat datang';
    final displayName = name ?? subtitle ?? '';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 23,
            backgroundColor: Color(0xFFEEF4FF),
            child: Icon(Icons.person, color: Color(0xFF2E6BFF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayTitle,
                  style: TextStyle(
                    color: textColor.withOpacity(0.9),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayName,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          // Notification button with optional badge
          Stack(
            children: [
              IconButton(
                onPressed: onNotification,
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF2E6BFF),
                ),
              ),
              // small red dot (example unread indicator)
              Positioned(
                right: 8,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
