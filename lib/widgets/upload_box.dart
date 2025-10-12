import 'dart:io';
import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final String label;
  final String? fileName;
  final String? imagePath; // local file path to show preview
  final VoidCallback onTap;

  const UploadBox({
    super.key,
    required this.label,
    required this.fileName,
    required this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final border = Border.all(color: const Color(0xFFDEE3EA), width: 1.2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 26),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(12),
              border: border,
              boxShadow: const [BoxShadow(color: Colors.transparent)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imagePath != null && imagePath!.isNotEmpty)
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imagePath!),
                          width: 120,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  )
                else
                  Icon(
                    Icons.file_upload_outlined,
                    size: 34,
                    color: Colors.grey[600],
                  ),

                const SizedBox(height: 8),

                Text(
                  fileName == null || fileName!.isEmpty
                      ? 'Upload foto KK/KTP (.png/.jpg)'
                      : fileName!,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
