import 'dart:async';

import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/responsive_layout.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/product_card.dart';
import 'package:flutter/material.dart';

class _Testimonial {
  final String name;
  final String initials;
  final double rating;
  final String comment;
  final String daysAgo;
  const _Testimonial(
    this.name,
    this.initials,
    this.rating,
    this.comment,
    this.daysAgo,
  );
}

const List<_Testimonial> _kTestimonials = [
  _Testimonial(
    'أحمد رمضان',
    'أ ر',
    5,
    'جودة الخامات فوق الممتازة والتوصيل كان أسرع مما توقعت، هرجع أطلب تاني أكيد.',
    'من 3 أيام',
  ),
  _Testimonial(
    'مريم عادل',
    'م ع',
    5,
    'أول مرة أشتري أونلاين وأحس إن الصورة مطابقة تماماً للمنتج الحقيقي، تجربة كويسة جدا.',
    'من أسبوع',
  ),
  _Testimonial(
    'كريم فتحي',
    'ك ف',
    4,
    'خدمة العملاء رائعة في الرد والاستبدال كان سهل جداً من غير أي تعقيد.',
    'من أسبوعين',
  ),
  _Testimonial(
    'سارة يوسف',
    'س ي',
    5,
    'التغليف فخم جداً وحسيت إني بافتح هدية مش أوردر عادي، تسلم إيدكم.',
    'من شهر',
  ),
  _Testimonial(
    'محمود جابر',
    'م ج',
    5,
    'أسعار مناسبة جداً بالنسبة للجودة، والفروع منتشرة فكان سهل أستلم من القريب مني.',
    'من شهر',
  ),
];

class TestimonialsCarousel extends StatefulWidget {
  const TestimonialsCarousel({super.key});

  @override
  State<TestimonialsCarousel> createState() => TestimonialsCarouselState();
}

class TestimonialsCarouselState extends State<TestimonialsCarousel> {
  late final PageController _ctrl;
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: 0.86);
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_ctrl.hasClients) return;
      try {
        final next = (_page + 1) % _kTestimonials.length;
        _ctrl.animateToPage(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      } catch (_) {
        // تجاهل بهدوء لو حصل تايمنج نادر مع تنقل الصفحات
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    return SizedBox(
      height: isWeb ? 190 : 176,
      child: PageView.builder(
        controller: _ctrl,
        itemCount: _kTestimonials.length,
        onPageChanged: (p) => setState(() => _page = p),
        itemBuilder: (context, i) {
          final t = _kTestimonials[i];
          final selected = i == _page;
          return AnimatedScale(
            duration: const Duration(milliseconds: 260),
            scale: selected ? 1.0 : 0.94,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 260),
              opacity: selected ? 1.0 : 0.6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _TestimonialCard(testimonial: t),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial testimonial;
  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    final t = testimonial;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.55),
        border: Border.all(color: AppColors.gold.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.15),
                ),
                child: Text(
                  t.initials,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      t.daysAgo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.format_quote_rounded,
                color: AppColors.gold.withOpacity(0.35),
                size: 26,
              ),
            ],
          ),
          const SizedBox(height: 10),
          RatingStars(rating: t.rating, size: 15),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              t.comment,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.6,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
