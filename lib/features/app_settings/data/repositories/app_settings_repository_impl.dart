import 'package:ecommerce_el7out/features/app_settings/data/datasources/app_settings_local_data_source.dart';
import 'package:ecommerce_el7out/features/app_settings/domain/entities/app_settings_entity.dart';
import 'package:ecommerce_el7out/features/app_settings/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsLocalDataSource _localDataSource;

  const AppSettingsRepositoryImpl(this._localDataSource);

  @override
  AppSettingsEntity loadSettings() => _localDataSource.load();

  @override
  Future<void> saveCurrency(AppCurrency currency) {
    return _localDataSource.saveCurrency(currency);
  }

  @override
  Future<void> saveLocale(String languageCode) {
    return _localDataSource.saveLocale(languageCode);
  }

  @override
  Future<void> savePushEnabled(bool enabled) {
    return _localDataSource.savePushEnabled(enabled);
  }

  @override
  Future<void> saveThemePreference(AppThemePreference preference) {
    return _localDataSource.saveThemePreference(preference);
  }
}
