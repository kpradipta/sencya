import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbershop_app/theme/colors.dart';

class AppTypography {
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.notoSerif(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.02 * 48,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.notoSerif(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.01 * 32,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.02 * 20,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.01 * 16,
        color: AppColors.textPrimary,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0.1 * 12,
        color: AppColors.textPrimary,
      ),
    );
  }
}
