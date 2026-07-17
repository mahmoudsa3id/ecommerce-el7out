import 'package:flutter/material.dart';
import 'bootstrap.dart';
import 'package:ecommerce_el7out/core/router/admin_router.dart';
import 'package:ecommerce_el7out/core/theme/app_theme.dart';
import 'package:ecommerce_el7out/l10n/app_localizations.dart';

Future<void> main() async {
  await bootstrap(enableSupabase: true);
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EL7OUT Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightFor(const Locale('en')),
      darkTheme: AppTheme.darkFor(const Locale('en')),
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: adminRouter,
    );
  }
}
