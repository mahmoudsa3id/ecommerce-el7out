// features/settings/presentation/cubit/settings_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

class AppSettings {
  final bool isDarkMode;
  final String currency;
  final String language;
  final String languageCode;
  final bool pushEnabled;

  const AppSettings({
    this.isDarkMode = false,
    this.currency = 'USD',
    this.language = 'English',
    this.languageCode = 'en',
    this.pushEnabled = true,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    String? currency,
    String? language,
    String? languageCode,
    bool? pushEnabled,
  }) => AppSettings(
    isDarkMode: isDarkMode ?? this.isDarkMode,
    currency: currency ?? this.currency,
    language: language ?? this.language,
    languageCode: languageCode ?? this.languageCode,
    pushEnabled: pushEnabled ?? this.pushEnabled,
  );
}

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = SettingsInitial;
  const factory SettingsState.loading() = SettingsLoading;
  const factory SettingsState.loaded(AppSettings settings) = SettingsLoaded;
  const factory SettingsState.error(String message) = SettingsError;
}
