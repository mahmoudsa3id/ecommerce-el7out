import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppCurrency {
  egp('EGP'),
  usd('USD'),
  eur('EUR');

  final String code;
  const AppCurrency(this.code);

  static AppCurrency fromCode(String code) {
    return AppCurrency.values.firstWhere(
      (currency) => currency.code == code.toUpperCase(),
      orElse: () => AppCurrency.egp,
    );
  }
}

enum AppThemePreference {
  light('light'),
  dark('dark'),
  system('system');

  final String storageKey;
  const AppThemePreference(this.storageKey);

  ThemeMode get themeMode {
    switch (this) {
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
      case AppThemePreference.light:
        return ThemeMode.light;
    }
  }

  static AppThemePreference fromStorageKey(String key) {
    return AppThemePreference.values.firstWhere(
      (preference) => preference.storageKey == key,
      orElse: () => AppThemePreference.light,
    );
  }
}

class AppSettingsEntity extends Equatable {
  final Locale locale;
  final AppThemePreference themePreference;
  final AppCurrency currency;
  final bool pushEnabled;

  const AppSettingsEntity({
    this.locale = const Locale('ar', 'EG'),
    this.themePreference = AppThemePreference.light,
    this.currency = AppCurrency.egp,
    this.pushEnabled = true,
  });

  ThemeMode get themeMode => themePreference.themeMode;
  bool get isArabic => locale.languageCode == 'ar';

  AppSettingsEntity copyWith({
    Locale? locale,
    AppThemePreference? themePreference,
    AppCurrency? currency,
    bool? pushEnabled,
  }) {
    return AppSettingsEntity(
      locale: locale ?? this.locale,
      themePreference: themePreference ?? this.themePreference,
      currency: currency ?? this.currency,
      pushEnabled: pushEnabled ?? this.pushEnabled,
    );
  }

  @override
  List<Object?> get props => [locale, themePreference, currency, pushEnabled];
}
