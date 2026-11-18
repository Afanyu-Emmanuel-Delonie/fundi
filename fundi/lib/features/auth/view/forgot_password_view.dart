import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../view_model/forgot_password_view_model.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/error_banner.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  late final AnimationController _enter = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1300));
  late final AnimationController _shake = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));

  late final List<Animation<double>> _steps = List.generate(4, (i) {
    final start = 0.25 + i * 0.1;
    return CurvedAnimation(
      parent: _enter,
      curve: Interval(start, math.min(start + 0.4, 1), curve: Curves.easeOutCubic),
    );
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _enter.value = 1;
    } else if (!_enter.isAnimating && _enter.value == 0) {
      _enter.forward();
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    _shake.dispose();
    _email.dispose();
    super.dispose();
  }

  void _shakeForm() {
    HapticFeedback.mediumImpact();
    _shake.forward(from: 0);
  }

  Future<void> _submit(ForgotPasswordViewModel vm) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _shakeForm();
      return;
    }
    final ok = await vm.sendReset(_email.text);
    if (!ok) _shakeForm();
  }

  Widget _reveal(int i, Widget child) {
    final a = _steps[i];
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(a),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: AppColors.surfaceMuted)),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        switchInCurve: Curves.easeOutCubic,
                        child: vm.sent ? _buildSent(vm) : _buildForm(vm),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const AuthBackground(),
        ],
      ),
    );
  }

  Widget _buildForm(ForgotPasswordViewModel vm) {
    return ListView(
      key: const ValueKey('form'),
      padding: const EdgeInsets.only(top: 8),
      children: [
        // ---------- Heading ----------
        _reveal(0, Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Forgot password?',
              style: AppTextStyles.display.copyWith(fontSize: 30, letterSpacing: -0.8)),
          const SizedBox(height: 10),
          Text('Enter the email on your account and we\'ll send you a link to reset it.',
              style: AppTextStyles.body.copyWith(color: AppColors.inkMuted, fontSize: 16)),
        ])),
        const SizedBox(height: 40),

        // ---------- Field (shake on error) ----------
        Form(
          key: _formKey,
          child: AnimatedBuilder(
            animation: _shake,
            builder: (context, child) {
              final t = _shake.value;
              final dx = math.sin(t * math.pi * 5) * 10 * (1 - t);
              return Transform.translate(offset: Offset(dx, 0), child: child);
            },
            child: _reveal(1, AuthTextField(
              label: 'Email',
              controller: _email,
              hint: 'jean@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
              onFieldSubmitted: (_) => _submit(vm),
            )),
          ),
        ),

        // ---------- Error banner ----------
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: vm.error == null
              ? const SizedBox(width: double.infinity)
              : Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ErrorBanner(vm.error!),
          ),
        ),
        const SizedBox(height: 28),

        // ---------- Send button ----------
        _reveal(2, PrimaryButton(
          label: 'Send reset link',
          loading: vm.isLoading,
          onPressed: () => _submit(vm),
        )),
        const SizedBox(height: 32),

        // ---------- Back to login ----------
        _reveal(3, Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Remembered it? ', style: AppTextStyles.body.copyWith(color: AppColors.inkMuted)),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text('Log in',
                  style: AppTextStyles.bodyStrong.copyWith(color: AppColors.primary)),
            ),
          ],
        )),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildSent(ForgotPasswordViewModel vm) {
    return Column(
      key: const ValueKey('sent'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_outlined, color: AppColors.primary, size: 38),
        ),
        const SizedBox(height: 28),
        Text('Check your email',
            textAlign: TextAlign.center,
            style: AppTextStyles.display.copyWith(fontSize: 26, letterSpacing: -0.6)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text.rich(
            TextSpan(
              style: AppTextStyles.body.copyWith(color: AppColors.inkMuted, fontSize: 16),
              children: [
                const TextSpan(text: 'We sent a password reset link to '),
                TextSpan(text: vm.sentTo ?? 'your email', style: AppTextStyles.bodyStrong.copyWith(color: AppColors.ink, fontSize: 16)),
                const TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        PrimaryButton(
          label: 'Back to login',
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: vm.isLoading ? null : () => vm.sendReset(_email.text),
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm)),
          child: Text("Didn't get it? Resend", style: AppTextStyles.bodyStrong.copyWith(color: AppColors.primary)),
        ),
      ],
    );
  }
}
