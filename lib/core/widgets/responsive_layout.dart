// ============================================================
// core/widgets/responsive_layout.dart  (FULL REPLACEMENT)
// ============================================================
import 'package:flutter/material.dart';

abstract class Breakpoints {
  static const double compact = 360;
  static const double mobile = 768;
  static const double tablet = 1024;
  static const double desktop = 1280;
  static const double wide = 1600;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width < Breakpoints.mobile;
  static bool isCompact(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width < Breakpoints.compact;

  static bool isTablet(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    return w >= Breakpoints.mobile && w < Breakpoints.desktop;
  }

  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width >= Breakpoints.desktop;

  static bool isWeb(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width >= Breakpoints.tablet;

  static int gridColumns(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    if (w >= Breakpoints.wide) return 5;
    if (w >= Breakpoints.desktop) return 4;
    if (w >= Breakpoints.tablet) return 3;
    if (w >= Breakpoints.mobile) return 3;
    return 2;
  }

  static double horizontalPadding(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    if (w >= Breakpoints.wide) return 120;
    if (w >= Breakpoints.desktop) return 80;
    if (w >= Breakpoints.tablet) return 40;
    if (w < Breakpoints.compact) return 16;
    return 20;
  }

  static double sidebarWidth(BuildContext ctx) => 240;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= Breakpoints.desktop && desktop != null) return desktop!;
    if (w >= Breakpoints.mobile && tablet != null) return tablet!;
    return mobile;
  }
}
