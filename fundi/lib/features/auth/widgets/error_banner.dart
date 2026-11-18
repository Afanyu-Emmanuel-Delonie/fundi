import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message,
              style: AppTextStyles.caption.copyWith(color: AppColors.danger, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}
