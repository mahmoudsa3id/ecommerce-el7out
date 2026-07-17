import 'package:ecommerce_el7out/core/formatters/app_currency_formatter.dart';
import 'package:ecommerce_el7out/features/app_settings/presentation/cubit/app_settings_cubit.dart';
import 'package:ecommerce_el7out/features/app_settings/presentation/cubit/app_settings_state.dart';
import 'package:ecommerce_el7out/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension AppContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String money(num amountInEgp) {
    final settings = select<AppSettingsCubit, AppSettingsState>(
      (cubit) => cubit.state,
    ).settings;
    return const AppCurrencyFormatter().format(
      amountInEgp,
      currency: settings.currency,
      locale: settings.locale,
    );
  }
}
