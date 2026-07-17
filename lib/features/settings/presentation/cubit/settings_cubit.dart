// features/settings/presentation/cubit/settings_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;
  SettingsCubit(this._prefs) : super(const SettingsState.initial());

  Future<void> load() async {
    emit(const SettingsState.loading());
    final storedLanguage =
        _prefs.getString(AppConstants.prefLanguage) ?? 'English';
    final localeCode = _resolveLocaleCode(storedLanguage);
    final settings = AppSettings(
      isDarkMode: _prefs.getBool(AppConstants.prefThemeMode) ?? false,
      currency: _prefs.getString(AppConstants.prefCurrency) ?? 'USD',
      language: storedLanguage,
      languageCode: localeCode,
      pushEnabled: _prefs.getBool('push_enabled') ?? true,
    );
    emit(SettingsState.loaded(settings));
  }

  Future<void> toggleDarkMode(bool value) async {
    await _prefs.setBool(AppConstants.prefThemeMode, value);
    _updateSettings((s) => s.copyWith(isDarkMode: value));
  }

  Future<void> setCurrency(String currency) async {
    await _prefs.setString(AppConstants.prefCurrency, currency);
    _updateSettings((s) => s.copyWith(currency: currency));
  }

  Future<void> setLanguage(String language) async {
    final localeCode = _resolveLocaleCode(language);
    await _prefs.setString(AppConstants.prefLanguage, language);
    _updateSettings(
      (s) => s.copyWith(language: language, languageCode: localeCode),
    );
  }

  Future<void> togglePush(bool value) async {
    await _prefs.setBool('push_enabled', value);
    _updateSettings((s) => s.copyWith(pushEnabled: value));
  }

  void _updateSettings(AppSettings Function(AppSettings) updater) {
    state.whenOrNull(
      loaded: (settings) => emit(SettingsState.loaded(updater(settings))),
    );
  }

  String _resolveLocaleCode(String language) {
    final normalized = language.toLowerCase();
    if (normalized.contains('arab')) return 'ar';
    return 'en';
  }
}
