import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _s(double size, double lineHeight, FontWeight weight,
      {Color color = AppColors.ink, double spacing = 0}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        color: color,
        letterSpacing: spacing,
      );

  static final display = _s(30, 36, FontWeight.w800, spacing: -0.6);
  static final title = _s(26, 32, FontWeight.w800, spacing: -0.5);
  static final heading = _s(18, 24, FontWeight.w800);
  static final subheading = _s(16, 22, FontWeight.w700);
  static final body = _s(15, 22, FontWeight.w400);
  static final bodyStrong = _s(15, 22, FontWeight.w700);
  static final button = _s(15, 20, FontWeight.w800);
  static final caption = _s(13, 18, FontWeight.w500, color: AppColors.inkMuted);
  static final label = _s(12, 16, FontWeight.w700, spacing: 0.2);
}