// core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// EL7OUT brand palette — luxury monochrome with a single gold accent,
/// inspired by Zara/COS restraint and Nike's bold contrast.
abstract class AppColors {
  // Brand
  static const Color gold = Color(0xFFC9A24B);
  static const Color goldLight = Color(0xFFE3CB8C);
  static const Color goldDark = Color(0xFF9A7B2E);

  // Neutrals — light
  static const Color lightBg = Color(0xFFFAFAF9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF2F1EF);
  static const Color lightBorder = Color(0xFFE6E4E1);
  static const Color lightOnBg = Color(0xFF14130F);
  static const Color lightOnSurfaceMuted = Color(0xFF6F6D67);

  // Neutrals — dark
  static const Color darkBg = Color(0xFF0B0B0A);
  static const Color darkSurface = Color(0xFF161513);
  static const Color darkSurfaceAlt = Color(0xFF201F1C);
  static const Color darkBorder = Color(0xFF2C2A26);
  static const Color darkOnBg = Color(0xFFF5F4F1);
  static const Color darkOnSurfaceMuted = Color(0xFF9C9A93);

  // Semantic
  static const Color success = Color(0xFF3F8A5D);
  static const Color error = Color(0xFFC0453B);
  static const Color warning = Color(0xFFD9A441);
  static const Color info = Color(0xFF4A7FB5);

  static const List<Color> shimmerLight = [
    Color(0xFFEDECEA),
    Color(0xFFF7F6F4),
    Color(0xFFEDECEA),
  ];
  static const List<Color> shimmerDark = [
    Color(0xFF1C1B19),
    Color(0xFF262522),
    Color(0xFF1C1B19),
  ];
}
