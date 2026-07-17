import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryPill extends StatefulWidget {
  final CategoryEntity cat;
  const CategoryPill({super.key, required this.cat});

  @override
  State<CategoryPill> createState() => CategoryPillState();
}

class CategoryPillState extends State<CategoryPill>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _pressCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    lowerBound: 0,
    upperBound: 0.04,
  );

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) => _pressCtrl.reverse(),
        onTapCancel: () => _pressCtrl.reverse(),
        onTap: () =>
            context.push(RoutePaths.categoryDetailPath(widget.cat.slug)),
        child: AnimatedBuilder(
          animation: _pressCtrl,
          builder: (_, child) =>
              Transform.scale(scale: 1 - _pressCtrl.value, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hovered
                        ? AppColors.gold.withOpacity(0.12)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: Border.all(
                      color: _hovered ? AppColors.gold : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: widget.cat.imageUrl != null
                        ? Image.network(
                            widget.cat.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _DefaultCatIcon(),
                          )
                        : _DefaultCatIcon(),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  widget.cat.name,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 15.5,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultCatIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Icon(Icons.checkroom_outlined, size: 28));
  }
}
