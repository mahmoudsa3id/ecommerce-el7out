// core/theme/app_typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Editorial display font for headlines, clean grotesk for UI text —
/// mirrors the Farfetch/COS "fashion magazine" typographic feel.
abstract class AppTypography {
  static TextTheme textTheme(Color onBg, Color onBgMuted, {Locale? locale}) {
    final isArabic = locale?.languageCode == 'ar';
    final display = isArabic
        ? GoogleFonts.cairoTextTheme()
        : GoogleFonts.playfairDisplayTextTheme();
    final body = isArabic
        ? GoogleFonts.cairoTextTheme()
        : GoogleFonts.interTextTheme();

    return TextTheme(
      displayLarge: display.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
        height: 1.05,
        color: onBg,
      ),
      displayMedium: display.displayMedium?.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.1,
        color: onBg,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: onBg,
      ),
      headlineMedium: display.headlineMedium?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: onBg,
      ),
      titleLarge: body.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onBg,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onBg,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: onBg,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: onBg,
      ),
      bodySmall: body.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onBgMuted,
      ),
      labelLarge: body.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: onBg,
      ),
      labelMedium: body.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: onBgMuted,
      ),
      labelSmall: body.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
        color: onBgMuted,
      ),
    );
  }
}
