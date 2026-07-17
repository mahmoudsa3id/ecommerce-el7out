import 'package:ecommerce_el7out/core/helper/helpers.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/map_grid_painter.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/map_pin.dart';
import 'package:flutter/material.dart';

class _BranchInfo {
  final String name;
  final String address;
  final String phone;
  const _BranchInfo(this.name, this.address, this.phone);
}

const List<_BranchInfo> _kBranches = [
  _BranchInfo(
    'فرع القاهرة',
    '  المهندسين عماير البترول عمارة نمرة 6 ',
    '+201272527991',
  ),
  _BranchInfo(
    'فرع الاسكندرية',
    'ش45 اسفل كوبري جمال عبد الناصر بجوار سامي الخواجة للكاوتش',
    '+201050604247',
  ),
  _BranchInfo(
    'فرع الإسكندرية',
    ' العصافرة شارع اطلس بجوار بنك فيصل ',
    '+201281860948',
  ),
  _BranchInfo(
    'فرع كفر الدوار',
    'شارع المحكمة امام جنينة المستقبل',
    '+201011443351',
  ),
  _BranchInfo('فرع كفر الدوار', 'السناهرة ش الرحمة  ', '+201288007086'),
  _BranchInfo(
    'فرع كفر الدوار',
    'المدخل شارع مستشفى الشاملة  ',
    '+201203001751',
  ),
];

class MapIllustration extends StatelessWidget {
  const MapIllustration({super.key});

  static const List<Alignment> _pinPositions = [
    Alignment(0.0, -0.1),
    Alignment(-0.25, 0.05),
    Alignment(-0.55, -0.7),
    Alignment(0.55, -0.35),
    Alignment(0.15, -0.75),
    Alignment(-0.1, 0.75),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E1A12), Color(0xFF122016)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: MapGridPainter())),
            for (int i = 0; i < _kBranches.length; i++)
              Align(
                alignment: _pinPositions[i],
                child: MapPin(label: '${i + 1}'),
              ),
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '6 فروع منتشرة في مصر',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_rounded, size: 15, color: Colors.black),
                    SizedBox(width: 5),
                    Text(
                      'افتح الخرائط',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchTile extends StatefulWidget {
  final _BranchInfo branch;
  const _BranchTile({required this.branch});

  @override
  State<_BranchTile> createState() => _BranchTileState();
}

class _BranchTileState extends State<_BranchTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final b = widget.branch;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceContainerHighest
              .withOpacity(_hovered ? 0.9 : 0.55),
          border: Border.all(
            color: _hovered ? AppColors.gold : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withOpacity(0.14),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppColors.gold,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    b.address,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              tooltip: 'اتصال',
              icon: const Icon(Icons.call_outlined, size: 20),
              onPressed: () => openUrl('tel:+${b.phone}'),
            ),
          ],
        ),
      ),
    );
  }
}

class BranchesSection extends StatelessWidget {
  const BranchesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlideIn(
          child: Row(
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
                'فروعنا',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'زورونا في أقرب فرع ليكم',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FadeSlideIn(
          delay: const Duration(milliseconds: 100),
          child: PerspectiveTilt(child: const MapIllustration()),
        ),
        const SizedBox(height: AppSpacing.lg),
        Column(
          children: List.generate(_kBranches.length, (i) {
            final b = _kBranches[i];
            return StaggeredEntrance(
              index: i,
              baseDelay: const Duration(milliseconds: 60),
              child: _BranchTile(branch: b),
            );
          }),
        ),
      ],
    );
  }
}
