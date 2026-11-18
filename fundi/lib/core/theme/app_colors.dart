import 'package:flutter/material.dart';

/// Screens are white. Blue only for main actions, active tab, progress.
class AppColors {
  AppColors._();

  // Surfaces
  static const background = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF4F6FB);
  static const line = Color(0xFFE1E6F0);

  // Text
  static const ink = Color(0xFF0B1020);
  static const inkMuted = Color(0xFF5A6278);

  // Brand
  static const primary = Color(0xFF012AED);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primarySoft = Color(0xFFE6EBFF);
  static const accent = Color(0xFF31BBFD);   // fills only, never text
  static const onAccent = Color(0xFF04254F);

  // Meaning
  static const verified = Color(0xFF13804A);     // Proven / Confirmed only
  static const verifiedText = Color(0xFF0E6B3C);
  static const verifiedSoft = Color(0xFFE2F4EA);
  static const amber = Color(0xFFF2994A);        // stars, waiting
  static const amberSoft = Color(0xFFFDEBDA);
  static const amberInk = Color(0xFF8A4206);     // quoted / waiting text
  static const danger = Color(0xFFB3261E);
  static const dangerSoft = Color(0xFFFBE4E2);
  static const lineStrong = Color(0xFFB4BCCC); // input borders
}