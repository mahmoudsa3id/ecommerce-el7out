// core/widgets/glass_container.dart
//
// Two small, reusable presentation-only widgets used by the luxury
// redesign. Neither touches any Cubit/repository/business logic.
import 'dart:ui';
import 'package:ecommerce_el7out/core/theme/luxory_pallete.dart';
import 'package:flutter/material.dart';

/// A frosted-glass ("glassmorphism") panel: blurred backdrop, tinted
/// translucent fill, subtle hairline border and a soft floating shadow.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final Color tint;
  final double tintOpacity;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final List<BoxShadow>? shadows;
  final Clip clipBehavior;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blurSigma = 18,
    this.tint = Colors.white,
    this.tintOpacity = 0.10,
    this.padding,
    this.border,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows ?? LuxuryPalette.floatingShadow(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: tint.withOpacity(tintOpacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border:
                  border ??
                  Border.all(
                    color: isDark
                        ? LuxuryPalette.glassBorderLight
                        : LuxuryPalette.glassBorderDark,
                    width: 1,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Wraps [child] with a subtle scale-down on press (mobile) and scale-up on
/// hover (web/desktop) — a cheap, consistent micro-interaction used by every
/// tappable card in the redesign.
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressScale;
  final double hoverScale;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressScale = 0.96,
    this.hoverScale = 1.02,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;
  bool _hovered = false;

  double get _scale {
    if (_pressed) return widget.pressScale;
    if (_hovered) return widget.hoverScale;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              boxShadow: _hovered
                  ? LuxuryPalette.floatingShadow(opacity: 0.22)
                  : LuxuryPalette.floatingShadow(opacity: 0.12),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
