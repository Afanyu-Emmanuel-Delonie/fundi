import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child});
  final Widget child;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false});
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.30),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            disabledBackgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: loading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : Row(
                    key: const ValueKey('label'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: AppTextStyles.button.copyWith(color: Colors.white)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
