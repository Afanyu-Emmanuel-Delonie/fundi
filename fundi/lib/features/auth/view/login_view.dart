import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../view_model/login_view_model.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/error_banner.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  late final AnimationController _enter = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1300));
  late final AnimationController _float = AnimationController(
      vsync: this, duration: const Duration(seconds: 6));
  late final AnimationController _shake = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));


  /// One entrance animation per section, staggered.
  late final List<Animation<double>> _steps = List.generate(7, (i) {
    final start = 0.25 + i * 0.07;
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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _shakeForm() {
    HapticFeedback.mediumImpact();
    _shake.forward(from: 0);
  }

  Future<void> _login(LoginViewModel vm) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _shakeForm();
      return;
    }
    final ok = await vm.login(_email.text, _password.text);
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
    final vm = context.watch<LoginViewModel>();

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
                    const SizedBox(height: 96),

                    // ---------- Heading ----------
                    _reveal(0, Column(children: [
                      Text('Welcome back',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.display.copyWith(fontSize: 32, letterSpacing: -0.8)),
                      const SizedBox(height: 10),
                      Text('Sign in to keep your jobs moving.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(color: AppColors.inkMuted, fontSize: 16)),
                    ])),
                    const SizedBox(height: 48),

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
                          _reveal(2, AuthTextField(
                            label: 'Password',
                            controller: _password,
                            hint: 'Your password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: vm.obscurePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onFieldSubmitted: (_) => _login(vm),
                            validator: Validators.password,
                            trailing: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/forgot-password'),
                              child: Text('Forgot password?',
                                  style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 13)),
                            ),
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

                    // ---------- Login button ----------
                    _reveal(3, PrimaryButton(
                      label: 'Login',
                      loading: vm.isLoading,
                      onPressed: () => _login(vm),
                    )),
                    const SizedBox(height: 40),

                    // ---------- Social ----------
                    _reveal(4, Row(children: [
                      const Expanded(child: Divider(color: AppColors.line, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('or continue with', style: AppTextStyles.caption),
                      ),
                      const Expanded(child: Divider(color: AppColors.line, thickness: 1)),
                    ])),
                    const SizedBox(height: 20),
                    _reveal(5, Row(
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

                    // ---------- Sign up ----------
                    _reveal(6, Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New to Fundi? ', style: AppTextStyles.body.copyWith(color: AppColors.inkMuted)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/signup'),
                          child: Text('Create an account',
                              style: AppTextStyles.bodyStrong.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    )),
                    const SizedBox(height: 150), // clear of the bottom curve
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
