import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:flutter/material.dart';

class VipRibbon extends StatelessWidget {
  const VipRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF0B0B0A), Color(0xFF1A1712), Color(0xFF0B0B0A)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.15),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.gold,
              size: 16,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'عضوية VIP — شحن مجاني وأولوية في العروض الحصرية',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.gold,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
