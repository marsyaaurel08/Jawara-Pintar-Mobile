import 'package:flutter/material.dart';
import '../theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading; // ✅ Tambahan baru

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false, // ✅ Default false
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kPrimaryBlue.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // ✅ Disable saat loading
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryBlue,
          minimumSize: const Size(double.infinity, 50), // tombol lebar penuh
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
