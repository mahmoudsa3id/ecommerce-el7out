// main.dart (COMPLETE REPLACEMENT)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bootstrap.dart';
import 'l10n/app_localizations.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/app_settings/presentation/cubit/app_settings_cubit.dart';
import 'features/app_settings/presentation/cubit/app_settings_state.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy(); // <-- أضف السطر ده

  await bootstrap(enableSupabase: true);
  runApp(const EL7OUTApp());
}

class EL7OUTApp extends StatelessWidget {
  const EL7OUTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        BlocProvider<CartCubit>(create: (_) => getIt<CartCubit>()..loadCart()),
        BlocProvider<AppSettingsCubit>(
          create: (_) => getIt<AppSettingsCubit>()..load(),
        ),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settingsState) {
          final settings = settingsState.settings;
          final locale = settings.locale;
          return MaterialApp.router(
            title: 'EL7OUT',

            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightFor(locale),

            darkTheme: AppTheme.darkFor(locale),
            themeMode: settings.themeMode,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: appRouter,
            builder: (context, child) => Directionality(
              textDirection: locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
