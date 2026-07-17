// ============================================================
// features/shell/presentation/pages/shell_page.dart  (FULL)
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';

class ShellPage extends StatefulWidget {
  final Widget child;
  const ShellPage({super.key, required this.child});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _tabIndex = 0;

  static const _mobileTabs = [
    RoutePaths.home,
    RoutePaths.categories,
    RoutePaths.wishlist,
    RoutePaths.profile,
  ];

  static const _webTabs = [
    RoutePaths.home,
    RoutePaths.categories,
    RoutePaths.search,
    RoutePaths.wishlist,
    RoutePaths.cart,
    RoutePaths.profile,
  ];

  void _onMobileTabTap(int i) {
    setState(() => _tabIndex = i);
    context.go(_mobileTabs[i]);
  }

  void _onWebTabTap(int i) {
    setState(() => _tabIndex = i);
    context.go(_webTabs[i]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: getIt<AuthCubit>())],
      child: ResponsiveLayout(
        mobile: _MobileShell(
          child: widget.child,
          tabIndex: _tabIndex,
          onTabTap: _onMobileTabTap,
        ),
        desktop: _WebShell(
          child: widget.child,
          tabIndex: _tabIndex,
          onTabTap: _onWebTabTap,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MOBILE SHELL
// ─────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  final Widget child;
  final int tabIndex;
  final ValueChanged<int> onTabTap;

  const _MobileShell({
    required this.child,
    required this.tabIndex,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _MobileBottomBar(
        currentIndex: tabIndex,
        onTap: onTabTap,
      ),
    );
  }
}

class _MobileBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MobileBottomBar({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavDef(Icons.home_outlined, Icons.home, null),
    _NavDef(Icons.grid_view_outlined, Icons.grid_view, null),
    _NavDef(Icons.favorite_outline, Icons.favorite, null),
    _NavDef(Icons.person_outline, Icons.person, null),
  ];

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final outline = Theme.of(context).colorScheme.outline;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(
          top: BorderSide(color: outline.withOpacity(0.4), width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 67,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: _MobileNavItem(
                  def: item,
                  selected: selected,
                  index: i,
                  onTap: () => onTap(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavDef {
  final IconData icon;
  final IconData activeIcon;
  final String? badge;

  const _NavDef(this.icon, this.activeIcon, this.badge);
}

class _MobileNavItem extends StatelessWidget {
  final _NavDef def;
  final bool selected;
  final int index;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.def,
    required this.selected,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final color = selected ? onSurface : onSurface.withOpacity(0.38);

    final baseIcon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, anim) =>
          ScaleTransition(scale: anim, child: child),
      child: Icon(
        selected ? def.activeIcon : def.icon,
        key: ValueKey(selected),
        size: 30,
        color: color,
      ),
    );
    final icon = baseIcon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 26, child: Center(child: icon)),
            const SizedBox(height: 2),
            SizedBox(
              height: 18,
              width: double.infinity,
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    color: color,
                    letterSpacing: 0.3,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _labelFor(context, index),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 4,
              width: selected ? 20 : 0,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFor(BuildContext context, int index) {
    final l10n = context.l10n;
    return switch (index) {
      0 => l10n.home,
      1 => l10n.shop,
      2 => l10n.saved,
      _ => l10n.account,
    };
  }
}

// ─────────────────────────────────────────────
// WEB SHELL – Professional sidebar like Farfetch/Net-a-Porter
// ─────────────────────────────────────────────
class _WebShell extends StatelessWidget {
  final Widget child;
  final int tabIndex;
  final ValueChanged<int> onTabTap;

  const _WebShell({
    required this.child,
    required this.tabIndex,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _WebSidebar(tabIndex: tabIndex, onTabTap: onTabTap),
          const VerticalDivider(width: 1, thickness: 0.5),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _WebSidebar extends StatelessWidget {
  final int tabIndex;
  final ValueChanged<int> onTabTap;

  const _WebSidebar({required this.tabIndex, required this.onTabTap});

  static const _navItems = [
    _WebNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, index: 0),
    _WebNavItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view,
      index: 1,
    ),
    _WebNavItem(icon: Icons.search, activeIcon: Icons.search, index: 2),
    _WebNavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      index: 3,
    ),
    _WebNavItem(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag,
      index: 4,
      isBag: true,
    ),
    _WebNavItem(icon: Icons.person_outline, activeIcon: Icons.person, index: 5),
  ];

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      width: 220,
      color: surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.appTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    letterSpacing: 5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.shop.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    letterSpacing: 2,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.45),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          // Nav items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _navItems.map((item) {
                return _WebSidebarTile(
                  item: item,
                  selected: tabIndex == item.index,
                  onTap: () => onTabTap(item.index),
                );
              }).toList(),
            ),
          ),
          // Bottom – auth status
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: state.maybeWhen(
                  authenticated: (user) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.gold.withOpacity(0.15),
                            child: Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : 'E',
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName.split(' ').first,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  context.l10n.account,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  orElse: () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => context.push(RoutePaths.login),
                        child: Row(
                          children: [
                            const Icon(Icons.login_outlined, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              context.l10n.signIn,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WebNavItem {
  final IconData icon;
  final IconData activeIcon;
  final int index;
  final bool isBag;

  const _WebNavItem({
    required this.icon,
    required this.activeIcon,
    required this.index,
    this.isBag = false,
  });
}

class _WebSidebarTile extends StatefulWidget {
  final _WebNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _WebSidebarTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_WebSidebarTile> createState() => _WebSidebarTileState();
}

class _WebSidebarTileState extends State<_WebSidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final active = widget.selected;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: active
                ? onSurface.withOpacity(0.07)
                : _hovered
                ? onSurface.withOpacity(0.04)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              widget.item.isBag
                  ? BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        final count = state.maybeWhen(
                          loaded: (items) =>
                              items.fold(0, (s, i) => s + i.quantity),
                          orElse: () => 0,
                        );
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              active
                                  ? widget.item.activeIcon
                                  : widget.item.icon,
                              size: 20,
                              color: active
                                  ? onSurface
                                  : onSurface.withOpacity(0.5),
                            ),
                            if (count > 0)
                              Positioned(
                                right: -8,
                                top: -6,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 15,
                                    minHeight: 15,
                                  ),
                                  padding: const EdgeInsets.all(1),
                                  decoration: const BoxDecoration(
                                    color: AppColors.gold,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$count',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    )
                  : Icon(
                      active ? widget.item.activeIcon : widget.item.icon,
                      size: 20,
                      color: active ? onSurface : onSurface.withOpacity(0.5),
                    ),
              const SizedBox(width: 14),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? onSurface : onSurface.withOpacity(0.6),
                  letterSpacing: 0.2,
                ),
                child: Text(_labelFor(context, widget.item.index)),
              ),
              if (active) ...[
                const Spacer(),
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _labelFor(BuildContext context, int index) {
    final l10n = context.l10n;
    return switch (index) {
      0 => l10n.home,
      1 => l10n.shop,
      2 => l10n.search,
      3 => l10n.wishlist,
      4 => l10n.bag,
      _ => l10n.account,
    };
  }
}
