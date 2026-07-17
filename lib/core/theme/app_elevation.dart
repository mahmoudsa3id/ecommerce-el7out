// core/theme/app_elevation.dart
import 'package:flutter/material.dart';

abstract class AppElevation {
  static List<BoxShadow> level1(Brightness b) => [
    BoxShadow(
      color: Colors.black.withOpacity(b == Brightness.dark ? 0.4 : 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> level2(Brightness b) => [
    BoxShadow(
      color: Colors.black.withOpacity(b == Brightness.dark ? 0.5 : 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> level3(Brightness b) => [
    BoxShadow(
      color: Colors.black.withOpacity(b == Brightness.dark ? 0.6 : 0.12),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];
}
