import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/core/widgets/responsive_layout.dart';
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/category_pill.dart';
import 'package:flutter/material.dart';

class CategoryHorizontalStrip extends StatelessWidget {
  final List<CategoryEntity> cats;

  const CategoryHorizontalStrip({super.key, required this.cats});

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    final pagePadding = ResponsiveLayout.horizontalPadding(context);
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb
            ? ResponsiveLayout.horizontalPadding(context)
            : pagePadding,
      ),
      itemCount: cats.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, i) {
        return StaggeredEntrance(
          index: i,
          baseDelay: const Duration(milliseconds: 40),
          child: CategoryPill(cat: cats[i]),
        );
      },
    );
  }
}
