import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color background = Color(0xFFF5F3EB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color inputBg = Color(0xFFEDEBE3);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color textLight = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFFE0DDD5);
  static const Color yellowAccent = Color(0xFFF5E6B8);
  static const Color redAccent = Color(0xFFD32F2F);
  static const Color greenLight = Color(0xFFE8F5E9);
  static const Color navInactive = Color(0xFF8A8A8A);
  static const Color brownGold = Color(0xFF8B6914);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        surface: AppColors.background,
      ),
      textTheme: GoogleFonts.beVietnamProTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.beVietnamPro(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGreen,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: GoogleFonts.beVietnamPro(
          color: AppColors.textLight,
          fontSize: 15,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
