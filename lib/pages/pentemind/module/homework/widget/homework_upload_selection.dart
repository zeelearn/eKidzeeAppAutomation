import 'package:flutter/material.dart';

class HomeworkUploadSection extends StatelessWidget {
  final VoidCallback? onUploadTap;
  final bool isSubmitted;

  const HomeworkUploadSection({
    super.key,
    required this.onUploadTap,
    this.isSubmitted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSubmitted) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Text(
          "Homework submitted",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onUploadTap,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F2FA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF6A1B9A)),
          ),
          child: Text(
            "Submit",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6A1B9A),
            ),
          ),
        ),
      ),
    );
  }
}
