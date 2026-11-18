import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.validator,
    this.suffix,
    this.onFieldSubmitted,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final Widget? suffix;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          Expanded(
            child: Text(label, style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.ink)),
          ),
          if (trailing != null) trailing!,
        ]),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          obscureText: obscureText,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            filled: false,
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            prefixIconColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.error)) return AppColors.danger;
              if (states.contains(WidgetState.focused)) return AppColors.primary;
              return AppColors.inkMuted;
            }),
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
