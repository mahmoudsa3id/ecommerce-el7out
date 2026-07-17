import 'package:bloc/bloc.dart';
import 'package:ecommerce_el7out/features/app_settings/domain/entities/app_settings_entity.dart';
import 'package:ecommerce_el7out/features/app_settings/domain/repositories/app_settings_repository.dart';
import 'package:flutter/widgets.dart';

import 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final AppSettingsRepository _repository;

  AppSettingsCubit(this._repository) : super(const AppSettingsState());

  void load() {
    emit(state.copyWith(loading: true));
    emit(
      state.copyWith(
        settings: _repository.loadSettings(),
        loading: false,
      ),
    );
  }

  Future<void> setLanguage(String languageCode) async {
    await _repository.saveLocale(languageCode);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          locale: languageCode == 'en'
              ? const Locale('en')
              : const Locale('ar', 'EG'),
        ),
      ),
    );
  }

  Future<void> setThemePreference(AppThemePreference preference) async {
    await _repository.saveThemePreference(preference);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(themePreference: preference),
      ),
    );
  }

  Future<void> setCurrency(AppCurrency currency) async {
    await _repository.saveCurrency(currency);
    emit(
      state.copyWith(settings: state.settings.copyWith(currency: currency)),
    );
  }

  Future<void> setPushEnabled(bool enabled) async {
    await _repository.savePushEnabled(enabled);
    emit(
      state.copyWith(settings: state.settings.copyWith(pushEnabled: enabled)),
    );
  }
}
