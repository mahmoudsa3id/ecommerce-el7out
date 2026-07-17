// ============================================================
// core/widgets/hoverable.dart  (FULL REPLACEMENT)
// ============================================================
import 'package:flutter/material.dart';

class Hoverable extends StatefulWidget {
  final Widget child;
  final double liftScale;
  final Duration duration;
  final bool enableShadow;

  const Hoverable({
    super.key,
    required this.child,
    this.liftScale = 1.025,
    this.duration = const Duration(milliseconds: 220),
    this.enableShadow = true,
  });

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _hovering ? widget.liftScale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: widget.duration,
          decoration: widget.enableShadow && _hovering
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.14),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                )
              : const BoxDecoration(),
          child: widget.child,
        ),
      ),
    );
  }
}
