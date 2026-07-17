// features/notifications/presentation/pages/notifications_page.dart
import 'package:ecommerce_el7out/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationCubit>()..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.notifications.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(letterSpacing: 3),
        ),
        centerTitle: false,
      ),
      body: AnimatedPageWrapper(
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (msg) => Center(child: Text(msg)),
              loaded: (items) => items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_outlined,
                            size: 56,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            context.l10n.emptyNotifications,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) => StaggeredListEntrance(
                        index: i,
                        child: _NotificationTile(
                          item: items[i],
                          onTap: () => context
                              .read<NotificationCubit>()
                              .markRead(items[i].id),
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity item;
  final VoidCallback onTap;
  const _NotificationTile({required this.item, required this.onTap});

  IconData _icon(NotificationType t) {
    switch (t) {
      case NotificationType.order:
        return Icons.local_shipping_outlined;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  Color _iconColor(NotificationType t) {
    switch (t) {
      case NotificationType.order:
        return AppColors.info;
      case NotificationType.promotion:
        return AppColors.gold;
      case NotificationType.system:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: item.isRead
          ? Colors.transparent
          : Theme.of(context).colorScheme.primary.withOpacity(0.04),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageHorizontal,
          vertical: AppSpacing.sm,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _iconColor(item.type).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon(item.type), color: _iconColor(item.type), size: 20),
        ),
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(item.body, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              _timeAgo(context, item.createdAt),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        trailing: !item.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }

  String _timeAgo(BuildContext context, DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 7) {
      return DateFormat.yMd(
        Localizations.localeOf(context).toString(),
      ).format(dt);
    }
    if (diff.inDays >= 1) return context.l10n.daysAgo(diff.inDays);
    if (diff.inHours >= 1) return context.l10n.hoursAgo(diff.inHours);
    if (diff.inMinutes >= 1) return context.l10n.minutesAgo(diff.inMinutes);
    return context.l10n.justNow;
  }
}
