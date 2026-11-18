import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repository/auth_repository.dart';
import 'features/auth/view/login_view.dart';
import 'features/auth/view_model/login_view_model.dart';

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
        '/signup': (_) => const Scaffold(body: Center(child: Text('Signup'))),
        '/home': (_) => const Scaffold(body: Center(child: Text('Home'))),
      },
    );
  }
}