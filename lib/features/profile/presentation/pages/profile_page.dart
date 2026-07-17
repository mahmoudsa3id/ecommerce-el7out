// ============================================================
// features/profile/presentation/pages/profile_page.dart (WEB-AWARE)
// ============================================================
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    final pad = isWeb
        ? ResponsiveLayout.horizontalPadding(context)
        : ResponsiveLayout.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.account.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(letterSpacing: 3),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RoutePaths.settings),
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
            unauthenticated: () => _GuestProfile(pad: pad),
            error: (_) => _GuestProfile(pad: pad),
            authenticated: (user) => isWeb
                ? _WebProfile(user: user, pad: pad)
                : _MobileProfile(user: user),
          );
        },
      ),
    );
  }
}

class _WebProfile extends StatelessWidget {
  final dynamic user;
  final double pad;
  const _WebProfile({required this.user, required this.pad});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left profile card
        SizedBox(
          width: 300,
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, 40, 24, 40),
            child: FadeSlideIn(
              child: Column(
                children: [
                  _Avatar(name: user.fullName, photoUrl: user.photoUrl),
                  const SizedBox(height: 20),
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.l10n.memberBadge.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    label: context.l10n.signOut.toUpperCase(),
                    variant: AppButtonVariant.outline,
                    onPressed: () => context.read<AuthCubit>().signOut(),
                  ),
                ],
              ),
            ),
          ),
        ),
        const VerticalDivider(width: 1, thickness: 0.5),
        // Right menu grid
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.all(pad),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: [
              _WebProfileTile(
                icon: Icons.receipt_long_outlined,
                label: context.l10n.myOrders,
                sub: context.l10n.trackAndManage,
                onTap: () => context.push(RoutePaths.orders),
              ),
              _WebProfileTile(
                icon: Icons.favorite_outline,
                label: context.l10n.wishlist,
                sub: context.l10n.savedItems,
                onTap: () => context.push(RoutePaths.wishlist),
              ),
              _WebProfileTile(
                icon: Icons.notifications_outlined,
                label: context.l10n.notifications,
                sub: context.l10n.updatesAndOffers,
                onTap: () => context.push(RoutePaths.notifications),
              ),
              _WebProfileTile(
                icon: Icons.location_on_outlined,
                label: context.l10n.addresses,
                sub: context.l10n.shippingInfo,
                onTap: () {},
              ),
              _WebProfileTile(
                icon: Icons.credit_card_outlined,
                label: context.l10n.payment,
                sub: context.l10n.cardsAndMethods,
                onTap: () {},
              ),
              _WebProfileTile(
                icon: Icons.settings_outlined,
                label: context.l10n.settings,
                sub: context.l10n.appPreferences,
                onTap: () => context.push(RoutePaths.settings),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WebProfileTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String sub;
  final VoidCallback onTap;

  const _WebProfileTile({
    required this.icon,
    required this.label,
    required this.sub,
    required this.onTap,
  });

  @override
  State<_WebProfileTile> createState() => _WebProfileTileState();
}

class _WebProfileTileState extends State<_WebProfileTile> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.04)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppColors.gold.withOpacity(0.4)
                  : Theme.of(context).colorScheme.outline.withOpacity(0.6),
              width: _hovered ? 1.3 : 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _hovered
                      ? AppColors.gold.withOpacity(0.12)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: _hovered ? AppColors.gold : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(widget.sub, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileProfile extends StatelessWidget {
  final dynamic user;
  const _MobileProfile({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          ScaleIn(
            child: _Avatar(name: user.fullName, photoUrl: user.photoUrl),
          ),
          const SizedBox(height: AppSpacing.md),
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: Text(
              user.fullName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 4),
          FadeSlideIn(
            delay: const Duration(milliseconds: 140),
            child: Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FadeSlideIn(
            delay: const Duration(milliseconds: 180),
            child: _MenuSection(
              items: [
                _MenuItem(
                  Icons.receipt_long_outlined,
                  context.l10n.myOrders,
                  AppColors.info,
                  () => context.push(RoutePaths.orders),
                ),
                _MenuItem(
                  Icons.favorite_outline,
                  context.l10n.wishlist,
                  AppColors.error,
                  () => context.push(RoutePaths.wishlist),
                ),
                _MenuItem(
                  Icons.notifications_outlined,
                  context.l10n.notifications,
                  AppColors.gold,
                  () => context.push(RoutePaths.notifications),
                ),
                _MenuItem(
                  Icons.location_on_outlined,
                  context.l10n.addresses,
                  AppColors.success,
                  () {},
                ),
                _MenuItem(
                  Icons.credit_card_outlined,
                  context.l10n.paymentMethods,
                  const Color(0xFF7B61FF),
                  () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FadeSlideIn(
            delay: const Duration(milliseconds: 220),
            child: AppButton(
              label: context.l10n.signOut.toUpperCase(),
              variant: AppButtonVariant.outline,
              onPressed: () => context.read<AuthCubit>().signOut(),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? photoUrl;
  const _Avatar({required this.name, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: photoUrl != null
            ? Image.network(photoUrl!, fit: BoxFit.cover)
            : Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'E',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
          width: 0.8,
        ),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              items[i],
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: 60,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _MenuItem(this.icon, this.label, this.iconColor, this.onTap);

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _pressed
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.04)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestProfile extends StatelessWidget {
  final double pad;
  const _GuestProfile({required this.pad});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(pad),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - pad * 2,
            ),
            child: FadeSlideIn(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleIn(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),
                        child: const Icon(Icons.person_outline, size: 48),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      context.l10n.guestProfileTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.guestProfileSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: AppButton(
                        label: context.l10n.signInButton.toUpperCase(),
                        onPressed: () => context.push(RoutePaths.login),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: OutlinedButton(
                        onPressed: () => context.push(RoutePaths.register),
                        child: Text(
                          context.l10n.createAccountButton.toUpperCase(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
