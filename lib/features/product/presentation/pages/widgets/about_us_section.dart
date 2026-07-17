import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/core/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class AboutUsSection extends StatelessWidget {
  const AboutUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    return FadeSlideIn(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isWeb ? AppSpacing.xxl : AppSpacing.xl),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surfaceContainerHighest,
              Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.gold.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'من نحن',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.gold.withOpacity(0.6),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'EL7OUT وجهتك المفضلة للأزياء العصرية، بنقدملك أحدث الموديلات '
              'بجودة عالية وأسعار مناسبة، ومعانا هتلاقي تشكيلة واسعة تناسب '
              'كل الأذواق، وخدمة عملاء سريعة ودعم مستمر في كل فروعنا.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.7,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: const [
                Expanded(
                  child: _AboutStat(value: '6+', label: 'فروع'),
                ),
                Expanded(
                  child: _AboutStat(value: '10K+', label: 'عميل سعيد'),
                ),
                Expanded(
                  child: _AboutStat(value: '4.8', label: 'تقييم عام'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutStat extends StatelessWidget {
  final String value;
  final String label;
  const _AboutStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// فروعنا (خريطة توضيحية محسّنة + قائمة فروع)
// ══════════════════════════════════════════════════════════════
