import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fundi/data/repository/auth_repository.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/view/forgot_password_view.dart';
import 'features/auth/view/login_view.dart';
import 'features/auth/view/register_view.dart';
import 'features/auth/view_model/forgot_password_view_model.dart';
import 'features/auth/view_model/login_view_model.dart';
import 'features/auth/view_model/register_view_model.dart';

import 'features/splash/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashView(),
      routes: {
        '/login': (_) => ChangeNotifierProvider(
          create: (_) => LoginViewModel(AuthRepository()),
          child: const LoginView(),
        ),
        '/signup': (_) => ChangeNotifierProvider(
          create: (_) => RegisterViewModel(AuthRepository()),
          child: const RegisterView(),
        ),
        '/forgot-password': (_) => ChangeNotifierProvider(
          create: (_) => ForgotPasswordViewModel(AuthRepository()),
          child: const ForgotPasswordView(),
        ),
        '/home': (_) => const Scaffold(body: Center(child: Text('Home'))),
      },
    );
  }
}