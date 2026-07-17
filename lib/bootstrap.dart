// bootstrap.dart (COMPLETE – updated with all new services)
import 'package:ecommerce_el7out/core/service/fcm_service.dart';
import 'package:ecommerce_el7out/core/service/remote_config_service.dart';
import 'package:ecommerce_el7out/features/app_settings/data/datasources/app_settings_local_data_source.dart';
import 'package:ecommerce_el7out/features/app_settings/data/repositories/app_settings_repository_impl.dart';
import 'package:ecommerce_el7out/features/app_settings/domain/repositories/app_settings_repository.dart';
import 'package:ecommerce_el7out/features/app_settings/presentation/cubit/app_settings_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/injection.dart';
import 'firebase_options.dart';

Future<void> bootstrap({
  bool enableSupabase = false,
  String? supabaseUrl,
  String? supabaseAnonKey,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (enableSupabase) {
    final url =
        supabaseUrl ??
        const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://cxalkgwmzjcqvtrotzsv.supabase.co',
        );
    final anonKey =
        supabaseAnonKey ??
        const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'sb_publishable_WpsuOlECOAB6yKRUu2vzdg_KfH-sEsI',
        );
    if (url.isEmpty || anonKey.isEmpty) {
      throw Exception(
        'Supabase configuration is missing. Pass SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define or function arguments.',
      );
    }
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  print('STEP 1');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('STEP 2');
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: kDebugMode
  //       ? AndroidProvider.debug
  //       : AndroidProvider.playIntegrity,
  //   appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
  // );

  print('STEP 3');

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  print('STEP 4');

  await configureDependencies();

  if (!getIt.isRegistered<AppSettingsRepository>()) {
    getIt.registerLazySingleton<AppSettingsRepository>(
      () => AppSettingsRepositoryImpl(
        AppSettingsLocalDataSource(getIt<SharedPreferences>()),
      ),
    );
  }
  if (!getIt.isRegistered<AppSettingsCubit>()) {
    getIt.registerLazySingleton<AppSettingsCubit>(
      () => AppSettingsCubit(getIt<AppSettingsRepository>()),
    );
  }

  print('STEP 5');

  await getIt<RemoteConfigService>().init();

  print('STEP 6');

  await getIt<FcmService>().init();

  print('DONE');
}
