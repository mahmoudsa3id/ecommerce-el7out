import 'package:ecommerce_el7out/features/app_settings/domain/entities/app_settings_entity.dart';
import 'package:equatable/equatable.dart';

class AppSettingsState extends Equatable {
  final AppSettingsEntity settings;
  final bool loading;

  const AppSettingsState({
    this.settings = const AppSettingsEntity(),
    this.loading = false,
  });

  AppSettingsState copyWith({
    AppSettingsEntity? settings,
    bool? loading,
  }) {
    return AppSettingsState(
      settings: settings ?? this.settings,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [settings, loading];
}
