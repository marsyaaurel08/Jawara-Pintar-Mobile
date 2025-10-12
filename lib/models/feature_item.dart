import 'package:flutter/material.dart';

class FeatureItem {
  final String id;
  final String title;
  final IconData icon;
  final Color bg;
  final VoidCallback onTap;

  FeatureItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.bg,
    required this.onTap,
  });
}
