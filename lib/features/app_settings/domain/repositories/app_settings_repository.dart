import '../entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  AppSettingsEntity loadSettings();
  Future<void> saveLocale(String languageCode);
  Future<void> saveThemePreference(AppThemePreference preference);
  Future<void> saveCurrency(AppCurrency currency);
  Future<void> savePushEnabled(bool enabled);
}
