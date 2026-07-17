import 'package:flutter/material.dart';

class GlowButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const GlowButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<GlowButton> createState() => GlowButtonState();
}

class GlowButtonState extends State<GlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          decoration: BoxDecoration(
            color: _hovered ? widget.color : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: widget.color, width: 1.2),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: _hovered ? Colors.black : widget.color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
