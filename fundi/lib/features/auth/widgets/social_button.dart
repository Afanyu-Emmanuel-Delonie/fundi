import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'primary_button.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.child, required this.onTap, required this.semanticLabel});
  final Widget child;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: PressableScale(
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(side: BorderSide(color: AppColors.line)),
          elevation: 0,
          shadowColor: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(width: 54, height: 54, child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}
