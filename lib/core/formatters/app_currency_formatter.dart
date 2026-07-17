import 'package:ecommerce_el7out/features/app_settings/domain/entities/app_settings_entity.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppCurrencyFormatter {
  static const Map<AppCurrency, double> _egpRates = {
    AppCurrency.egp: 1,
    AppCurrency.usd: 0.021,
    AppCurrency.eur: 0.019,
  };

  const AppCurrencyFormatter();

  String format(
    num amountInEgp, {
    required AppCurrency currency,
    required Locale locale,
  }) {
    final converted = amountInEgp * (_egpRates[currency] ?? 1);
    final localeName = locale.languageCode == 'ar' ? 'ar_EG' : 'en_US';
    final formatter = NumberFormat.currency(
      locale: localeName,
      name: currency.code,
      symbol: _symbolFor(currency, locale),
      decimalDigits: currency == AppCurrency.egp ? 0 : 2,
    );
    return formatter.format(converted);
  }

  String _symbolFor(AppCurrency currency, Locale locale) {
    if (locale.languageCode == 'ar') {
      switch (currency) {
        case AppCurrency.egp:
          return 'ج.م';
        case AppCurrency.usd:
          return 'دولار';
        case AppCurrency.eur:
          return 'يورو';
      }
    }
    return currency.code;
  }
}
