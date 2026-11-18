import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.lineStrong, width: 1.5),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primarySoft,
        secondary: AppColors.accent,
        onSecondary: AppColors.onAccent,
        surface: AppColors.background,
        onSurface: AppColors.ink,
        error: AppColors.danger,
        outline: AppColors.line,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),

      // White screens -> dark status bar icons
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(54),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: AppColors.line),
          textStyle: AppTextStyles.button.copyWith(fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button.copyWith(fontSize: 14),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.inkMuted),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
      ),


      chipTheme: ChipThemeData(
        backgroundColor: AppColors.background,
        selectedColor: AppColors.primarySoft,
        side: const BorderSide(color: AppColors.line),
        labelStyle: AppTextStyles.label,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.primarySoft,
        labelTextStyle: WidgetStatePropertyAll(AppTextStyles.label),
      ),

      dividerTheme:
      const DividerThemeData(color: AppColors.line, thickness: 1),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
      ),
    );
  }
}