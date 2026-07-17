import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/features/app_settings/domain/entities/app_settings_entity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsLocalDataSource {
  final SharedPreferences _prefs;

  const AppSettingsLocalDataSource(this._prefs);

  AppSettingsEntity load() {
    final languageCode = _prefs.getString(AppConstants.prefLanguage) ?? 'ar';
    final themeKey =
        _prefs.getString(AppConstants.prefThemeMode) ??
        AppThemePreference.light.storageKey;
    final currencyCode =
        _prefs.getString(AppConstants.prefCurrency) ?? AppCurrency.egp.code;

    return AppSettingsEntity(
      locale: languageCode == 'en'
          ? const Locale('en')
          : const Locale('ar', 'EG'),
      themePreference: AppThemePreference.fromStorageKey(themeKey),
      currency: AppCurrency.fromCode(currencyCode),
      pushEnabled: _prefs.getBool('push_enabled') ?? true,
    );
  }

  Future<void> saveLocale(String languageCode) {
    return _prefs.setString(AppConstants.prefLanguage, languageCode);
  }

  Future<void> saveThemePreference(AppThemePreference preference) {
    return _prefs.setString(
      AppConstants.prefThemeMode,
      preference.storageKey,
    );
  }

  Future<void> saveCurrency(AppCurrency currency) {
    return _prefs.setString(AppConstants.prefCurrency, currency.code);
  }

  Future<void> savePushEnabled(bool enabled) {
    return _prefs.setBool('push_enabled', enabled);
  }
}
