import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  // Backwards-compatible fields: older code used `greeting` and `subtitle`.
  final String? greeting;
  final String? subtitle;

  // New fields preferred by updated UI
  final String? title;
  final String? name;

  final VoidCallback? onNotification;
  final VoidCallback? onProfileTap;

  const DashboardHeader({
    super.key,
    // old
    this.greeting,
    this.subtitle,
    // new
    this.title,
    this.name,
    this.onNotification,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    // Choose display values (prefer new fields, fallback to old ones)
    final displayTitle = title ?? greeting ?? 'Selamat datang';
    final displayName = name ?? subtitle ?? '';

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              // Avatar dengan gradient
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 5, 117, 209),
                        Color.fromARGB(255, 3, 95, 170),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 5, 117, 209).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Text greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayTitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Notification Icon dengan badge
              GestureDetector(
                onTap: onNotification,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Colors.grey.shade700,
                        size: 24,
                      ),
                      // Badge notifikasi
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
