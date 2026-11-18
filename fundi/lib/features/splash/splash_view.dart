import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif_view/gif_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final GifController _controller = GifController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF012AED),
        body: Center(
          child: ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.94, // keeps the bottom 94%, cutting the top 6%
              child: GifView.asset(
                'assets/splash/splash.gif',
                controller: _controller,
                width: 1200,
                height: 1600,
                loop: false,
                onFinish: () {
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}