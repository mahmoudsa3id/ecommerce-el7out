// core/theme/luxury_palette.dart
//
// Additive visual language for the "luxury fashion" redesign of the
// Category and Product Details screens. This does NOT replace or modify
// `AppColors` — every other screen that already depends on AppColors is
// left completely untouched. Import this only where the new premium look
// is needed.
import 'package:flutter/material.dart';

class LuxuryPalette {
  LuxuryPalette._();

  static const Color ink = Color(0xFF0B0B0D);
  static const Color inkSoft = Color(0xFF17171A);
  static const Color ivory = Color(0xFFFAF8F5);
  static const Color champagne = Color(0xFFC9A25B);
  static const Color champagneLight = Color(0xFFE9D2A0);
  static const Color champagneDeep = Color(0xFFA9803F);

  static const Color glassBorderLight = Color(0x33FFFFFF);
  static const Color glassBorderDark = Color(0x14000000);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [champagneLight, champagne, champagneDeep],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroScrim = LinearGradient(
    colors: [Color(0x00000000), Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.30, 1.0],
  );

  static const LinearGradient cardScrim = LinearGradient(
    colors: [Color(0x00000000), Color(0xE6000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.45, 1.0],
  );

  /// Soft, deep, "floating" drop shadow used across premium cards & panels.
  static List<BoxShadow> floatingShadow({double opacity = 0.16}) => [
    BoxShadow(
      color: Colors.black.withOpacity(opacity),
      blurRadius: 34,
      offset: const Offset(0, 18),
      spreadRadius: -10,
    ),
    BoxShadow(
      color: champagne.withOpacity(0.05),
      blurRadius: 60,
      offset: const Offset(0, 26),
      spreadRadius: -18,
    ),
  ];

  static TextStyle eyebrow(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall?.copyWith(
        color: champagne,
        letterSpacing: 3,
        fontWeight: FontWeight.w600,
      ) ??
      const TextStyle(color: champagne, letterSpacing: 3);
}
