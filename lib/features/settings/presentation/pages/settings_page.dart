import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/extensions/app_context_extensions.dart';
import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animated_page_wrapper.dart';
import 'package:ecommerce_el7out/features/app_settings/domain/entities/app_settings_entity.dart';
import 'package:ecommerce_el7out/features/app_settings/presentation/cubit/app_settings_cubit.dart';
import 'package:ecommerce_el7out/features/app_settings/presentation/cubit/app_settings_state.dart';
import 'package:ecommerce_el7out/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AppSettingsCubit>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(letterSpacing: 3),
        ),
      ),
      body: AnimatedPageWrapper(
        child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
          builder: (context, state) {
            final settings = state.settings;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              children: [
                _SettingsSection(
                  title: l10n.appearance,
                  items: [
                    _SettingsItem(
                      icon: Icons.contrast_outlined,
                      title: l10n.theme,
                      subtitle: _themeLabel(context, settings.themePreference),
                      onTap: () => _showThemePicker(context, settings),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _SettingsSection(
                  title: l10n.preferences,
                  items: [
                    _SettingsItem(
                      icon: Icons.language_outlined,
                      title: l10n.language,
                      subtitle: settings.isArabic ? l10n.arabic : l10n.english,
                      onTap: () => _showLanguagePicker(context, settings),
                    ),
                    _SettingsItem(
                      icon: Icons.payments_outlined,
                      title: l10n.currency,
                      subtitle: settings.currency.code,
                      onTap: () => _showCurrencyPicker(context, settings),
                    ),
                    _SettingsItem(
                      icon: Icons.notifications_none_outlined,
                      title: l10n.pushNotifications,
                      subtitle: l10n.notifications,
                      trailing: Switch.adaptive(
                        value: settings.pushEnabled,
                        activeColor: AppColors.gold,
                        onChanged: context
                            .read<AppSettingsCubit>()
                            .setPushEnabled,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _SettingsSection(
                  title: l10n.about,
                  items: [
                    _SettingsItem(
                      icon: Icons.info_outline,
                      title: l10n.version,
                      subtitle: '1.0.0',
                    ),
                    _SettingsItem(
                      icon: Icons.privacy_tip_outlined,
                      title: l10n.privacyPolicy,
                      onTap: () => _showInfoDialog(context, l10n.privacyPolicy),
                    ),
                    _SettingsItem(
                      icon: Icons.description_outlined,
                      title: l10n.terms,
                      onTap: () => _showInfoDialog(context, l10n.terms),
                    ),
                    _SettingsItem(
                      icon: Icons.support_agent_outlined,
                      title: l10n.contactUs,
                      onTap: () => _showInfoDialog(context, l10n.contactUs),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _SettingsSection(
                  title: l10n.account,
                  items: [
                    _SettingsItem(
                      icon: Icons.logout,
                      title: l10n.logout,
                      onTap: () async {
                        await context.read<AuthCubit>().signOut();
                        if (context.mounted) context.go(RoutePaths.authGate);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            );
          },
        ),
      ),
    );
  }

  String _themeLabel(BuildContext context, AppThemePreference preference) {
    final l10n = context.l10n;
    switch (preference) {
      case AppThemePreference.dark:
        return l10n.dark;
      case AppThemePreference.system:
        return l10n.system;
      case AppThemePreference.light:
        return l10n.light;
    }
  }

  void _showThemePicker(BuildContext context, AppSettingsEntity settings) {
    final l10n = context.l10n;
    _showPicker<AppThemePreference>(
      context: context,
      title: l10n.selectTheme,
      selected: settings.themePreference,
      options: AppThemePreference.values,
      labelBuilder: (value) => _themeLabel(context, value),
      onSelected: context.read<AppSettingsCubit>().setThemePreference,
    );
  }

  void _showCurrencyPicker(BuildContext context, AppSettingsEntity settings) {
    _showPicker<AppCurrency>(
      context: context,
      title: context.l10n.selectCurrency,
      selected: settings.currency,
      options: AppCurrency.values,
      labelBuilder: (value) => value.code,
      onSelected: context.read<AppSettingsCubit>().setCurrency,
    );
  }

  void _showLanguagePicker(BuildContext context, AppSettingsEntity settings) {
    final l10n = context.l10n;
    _showPicker<String>(
      context: context,
      title: l10n.selectLanguage,
      selected: settings.locale.languageCode,
      options: const ['ar', 'en'],
      labelBuilder: (value) => value == 'ar' ? l10n.arabic : l10n.english,
      onSelected: context.read<AppSettingsCubit>().setLanguage,
    );
  }

  void _showInfoDialog(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(context.l10n.appTitle),
        actions: [
          TextButton(
            onPressed: context.pop,
            child: Text(context.l10n.close),
          ),
        ],
      ),
    );
  }

  void _showPicker<T>({
    required BuildContext context,
    required String title,
    required T selected,
    required List<T> options,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                title,
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            ...options.map(
              (option) => RadioListTile<T>(
                value: option,
                groupValue: selected,
                activeColor: AppColors.gold,
                title: Text(labelBuilder(option)),
                onChanged: (value) {
                  if (value == null) return;
                  onSelected(value);
                  Navigator.of(sheetContext).pop();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
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
                      indent: 56,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 21),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle!, style: Theme.of(context).textTheme.bodySmall)
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right_rounded, size: 20)
              : null),
      onTap: onTap,
    );
  }
}
