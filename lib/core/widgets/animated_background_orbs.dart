import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBackgroundOrbs extends StatefulWidget {
  const AnimatedBackgroundOrbs({super.key});

  @override
  State<AnimatedBackgroundOrbs> createState() => AnimatedBackgroundOrbsState();
}

class AnimatedBackgroundOrbsState extends State<AnimatedBackgroundOrbs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 25),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = _controller.value * 2 * math.pi;
          return Stack(
            children: [
              Positioned(
                top: 40 + math.sin(t) * 15,
                right: -60,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xffD4AF37).withOpacity(.18),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -70,
                top: 300 + math.cos(t) * 20,
                child: Transform.rotate(
                  angle: -.3,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xffD4AF37).withOpacity(.05),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 180,
                left: 80,
                child: Container(
                  width: 220,
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
              Positioned(
                right: 100,
                bottom: 80,
                child: Container(
                  width: 2,
                  height: 180,
                  color: Colors.grey.shade300,
                ),
              ),
              Positioned(
                bottom: 60 + math.sin(t * .8) * 15,
                left: 70,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xffD4AF37).withOpacity(.2),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 180,
                top: 260,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffD4AF37).withOpacity(.08),
                        blurRadius: 90,
                        spreadRadius: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// من نحن
// ══════════════════════════════════════════════════════════════
