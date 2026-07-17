import 'dart:math' as math;

import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LuxuryDivider extends StatelessWidget {
  const LuxuryDivider({super.key});

  @override
  Widget build(BuildContext context) {
    Widget line() => Expanded(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gold.withOpacity(0.0),
              AppColors.gold.withOpacity(0.6),
            ],
          ),
        ),
      ),
    );
    Widget lineReversed() => Expanded(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gold.withOpacity(0.6),
              AppColors.gold.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );

    return Row(
      children: [
        line(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        lineReversed(),
      ],
    );
  }
}
