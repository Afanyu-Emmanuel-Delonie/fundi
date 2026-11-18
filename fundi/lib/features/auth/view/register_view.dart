import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../view_model/register_view_model.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/error_banner.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  late final AnimationController _enter = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1300));
  late final AnimationController _float = AnimationController(
      vsync: this, duration: const Duration(seconds: 6));
  late final AnimationController _shake = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));

  /// One entrance animation per section, staggered.
  late final List<Animation<double>> _steps = List.generate(8, (i) {
    final start = 0.2 + i * 0.065;
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
      _float.stop();
    } else if (!_enter.isAnimating && _enter.value == 0) {
      _enter.forward();
      _float.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    _float.dispose();
    _shake.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _shakeForm() {
    HapticFeedback.mediumImpact();
    _shake.forward(from: 0);
  }

  Future<void> _register(RegisterViewModel vm) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _shakeForm();
      return;
    }
    final ok = await vm.register(
      name: _name.text,
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    if (ok) {
      HapticFeedback.lightImpact();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _shakeForm();
    }
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
    final vm = context.watch<RegisterViewModel>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: AppColors.surfaceMuted)),
          const AuthBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 72),

                    // ---------- Back ----------
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
                    ),
                    const SizedBox(height: 12),

                    // ---------- Heading ----------
                    _reveal(0, Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Create an account',
                          style: AppTextStyles.display.copyWith(fontSize: 30, letterSpacing: -0.8)),
                      const SizedBox(height: 10),
                      Text('Join Fundi and start getting jobs done.',
                          style: AppTextStyles.body.copyWith(color: AppColors.inkMuted, fontSize: 16)),
                    ])),
                    const SizedBox(height: 40),

                    // ---------- Fields (shake on error) ----------
                    AnimatedBuilder(
                      animation: _shake,
                      builder: (context, child) {
                        final t = _shake.value;
                        final dx = math.sin(t * math.pi * 5) * 10 * (1 - t);
                        return Transform.translate(offset: Offset(dx, 0), child: child);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _reveal(1, AuthTextField(
                            label: 'Full name',
                            controller: _name,
                            hint: 'Jean Mutoni',
                            icon: Icons.person_outline_rounded,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            validator: Validators.name,
                          )),
                          const SizedBox(height: 20),
                          _reveal(2, AuthTextField(
                            label: 'Email',
                            controller: _email,
                            hint: 'jean@example.com',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            validator: Validators.email,
                          )),
                          const SizedBox(height: 20),
                          _reveal(3, AuthTextField(
                            label: 'Password',
                            controller: _password,
                            hint: 'At least 6 characters',
                            icon: Icons.lock_outline_rounded,
                            obscureText: vm.obscurePassword,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            validator: Validators.password,
                            suffix: IconButton(
                              onPressed: vm.togglePassword,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  vm.obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  key: ValueKey(vm.obscurePassword),
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(height: 20),
                          _reveal(4, AuthTextField(
                            label: 'Confirm password',
                            controller: _confirmPassword,
                            hint: 'Re-enter your password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: vm.obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _register(vm),
                            validator: (value) => Validators.confirmPassword(value, _password.text),
                            suffix: IconButton(
                              onPressed: vm.toggleConfirmPassword,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  vm.obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  key: ValueKey(vm.obscureConfirmPassword),
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ),
                          )),
                        ],
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

                    // ---------- Create account button ----------
                    _reveal(5, PrimaryButton(
                      label: 'Create account',
                      loading: vm.isLoading,
                      onPressed: () => _register(vm),
                    )),
                    const SizedBox(height: 40),

                    // ---------- Social ----------
                    _reveal(6, Row(children: [
                      const Expanded(child: Divider(color: AppColors.line, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('or sign up with', style: AppTextStyles.caption),
                      ),
                      const Expanded(child: Divider(color: AppColors.line, thickness: 1)),
                    ])),
                    const SizedBox(height: 20),
                    _reveal(6, Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton(
                          semanticLabel: 'Continue with Google',
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/google.png',
                            width: 22,
                            errorBuilder: (_, __, ___) => const Text('G',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SocialButton(
                          semanticLabel: 'Continue with Apple',
                          onTap: () {},
                          child: const Icon(Icons.apple, size: 26, color: Colors.black),
                        ),
                        const SizedBox(width: 16),
                        SocialButton(
                          semanticLabel: 'Continue with Facebook',
                          onTap: () {},
                          child: const Icon(Icons.facebook, size: 25, color: Color(0xFF1877F2)),
                        ),
                      ],
                    )),
                    const SizedBox(height: 40),

                    // ---------- Log in ----------
                    _reveal(7, Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: AppTextStyles.body.copyWith(color: AppColors.inkMuted)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: Text('Log in',
                              style: AppTextStyles.bodyStrong.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    )),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
