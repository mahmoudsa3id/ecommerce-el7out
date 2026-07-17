// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_analytics/firebase_analytics.dart' as _i398;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:firebase_remote_config/firebase_remote_config.dart' as _i627;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/sign_in_usecase.dart' as _i259;
import '../../features/auth/domain/usecases/sign_up_usecase.dart' as _i860;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/cart/data/datasource/cart_local_datasource.dart'
    as _i572;
import '../../features/cart/data/repository/cart_repository_impl.dart'
    as _i1063;
import '../../features/cart/domain/repository/cart_repository.dart' as _i26;
import '../../features/cart/presentation/cubit/cart_cubit.dart' as _i499;
import '../../features/category/data/datasources/category_remote_data_source.dart'
    as _i848;
import '../../features/category/data/repository/category_repository_impl.dart'
    as _i1004;
import '../../features/category/domain/repository/category_repository.dart'
    as _i847;
import '../../features/category/domain/usecase/get_category_usecase.dart'
    as _i802;
import '../../features/category/presentation/cubit/category_cubit.dart'
    as _i859;
import '../../features/notification/data/datasources/notification_remote_datasource.dart'
    as _i227;
import '../../features/notification/presentation/cubit/notification_cubit.dart'
    as _i369;
import '../../features/order/data/datasource/order_remote_datasource.dart'
    as _i719;
import '../../features/order/data/repository/order_repository_impl.dart'
    as _i292;
import '../../features/order/domain/repository/order_repository.dart' as _i18;
import '../../features/order/presentation/cubit/order_cubit.dart' as _i304;
import '../../features/payment/data/datasources/payment_remote_datasource.dart'
    as _i247;
import '../../features/payment/data/repository/payment_repository_impl.dart'
    as _i929;
import '../../features/payment/domain/repository/payment_repository.dart'
    as _i267;
import '../../features/payment/presentation/cubit/payment_cubit.dart' as _i513;
import '../../features/product/data/datasources/product_remote_datasource.dart'
    as _i963;
import '../../features/product/data/repositories/product_repository_impl.dart'
    as _i1040;
import '../../features/product/domain/repositories/product_repository.dart'
    as _i39;
import '../../features/product/domain/usecases/get_products_by_id_usecase.dart'
    as _i836;
import '../../features/product/domain/usecases/get_products_usecase.dart'
    as _i1035;
import '../../features/product/presentation/cubits/product_cubit.dart' as _i320;
import '../../features/settings/presentation/cubit/settings_cubit.dart'
    as _i792;
import '../../features/wishlist/data/datasource/wishlist_local_datasource.dart'
    as _i644;
import '../../features/wishlist/data/repository/wishlist_repository_impl.dart'
    as _i669;
import '../../features/wishlist/domain/repository/wishlist_repository.dart'
    as _i780;
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart'
    as _i692;
import '../network/network_info.dart' as _i932;
import '../service/admin_notification_service.dart' as _i786;
import '../service/analytics_servic.dart' as _i44;
import '../service/fcm_service.dart' as _i4;
import '../service/image_picker_service.dart' as _i353;
import '../service/paymob_service.dart' as _i873;
import '../service/remote_config_service.dart' as _i833;
import '../service/supabse_storage_service.dart' as _i244;
import 'firebase_module.dart' as _i616;
import 'supabase_module.dart' as _i695;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    final supabaseModule = _$SupabaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => firebaseModule.firebaseMessaging,
    );
    gh.lazySingleton<_i627.FirebaseRemoteConfig>(
      () => firebaseModule.remoteConfig,
    );
    gh.lazySingleton<_i895.Connectivity>(() => firebaseModule.connectivity);
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.lazySingleton<_i398.FirebaseAnalytics>(() => supabaseModule.analytics);
    gh.lazySingleton<_i873.PayMobService>(() => _i873.PayMobService());
    gh.lazySingleton<_i353.ImagePickerService>(
      () => _i353.ImagePickerService(),
    );
    gh.factory<_i792.SettingsCubit>(
      () => _i792.SettingsCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i4.FcmService>(
      () => _i4.FcmService(gh<_i892.FirebaseMessaging>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i227.NotificationRemoteDataSource>(
      () =>
          _i227.NotificationRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i572.CartLocalDataSource>(
      () => _i572.CartLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i848.CategoryRemoteDataSource>(
      () => _i848.CategoryRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i644.WishlistLocalDataSource>(
      () => _i644.WishlistLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i26.CartRepository>(
      () => _i1063.CartRepositoryImpl(gh<_i572.CartLocalDataSource>()),
    );
    gh.lazySingleton<_i963.ProductRemoteDataSource>(
      () => _i963.ProductRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i786.AdminNotificationService>(
      () => _i786.AdminNotificationService(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i244.SupabaseStorageService>(
      () => _i244.SupabaseStorageService(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i44.AnalyticsService>(
      () => _i44.AnalyticsService(gh<_i398.FirebaseAnalytics>()),
    );
    gh.lazySingleton<_i247.PaymentRemoteDataSource>(
      () => _i247.PaymentRemoteDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
        gh<_i873.PayMobService>(),
        gh<_i244.SupabaseStorageService>(),
      ),
    );
    gh.lazySingleton<_i833.RemoteConfigService>(
      () => _i833.RemoteConfigService(gh<_i627.FirebaseRemoteConfig>()),
    );
    gh.lazySingleton<_i39.ProductRepository>(
      () => _i1040.ProductRepositoryImpl(
        gh<_i963.ProductRemoteDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i780.WishlistRepository>(
      () => _i669.WishlistRepositoryImpl(gh<_i644.WishlistLocalDataSource>()),
    );
    gh.factory<_i692.WishlistCubit>(
      () => _i692.WishlistCubit(
        gh<_i780.WishlistRepository>(),
        gh<_i44.AnalyticsService>(),
      ),
    );
    gh.lazySingleton<_i499.CartCubit>(
      () => _i499.CartCubit(
        gh<_i26.CartRepository>(),
        gh<_i44.AnalyticsService>(),
      ),
    );
    gh.lazySingleton<_i847.CategoryRepository>(
      () => _i1004.CategoryRepositoryImpl(
        gh<_i848.CategoryRemoteDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i267.PaymentRepository>(
      () => _i929.PaymentRepositoryImpl(
        gh<_i247.PaymentRemoteDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.factory<_i259.SignInUseCase>(
      () => _i259.SignInUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i860.SignUpUseCase>(
      () => _i860.SignUpUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i836.GetProductByIdUseCase>(
      () => _i836.GetProductByIdUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i1035.GetProductsUseCase>(
      () => _i1035.GetProductsUseCase(gh<_i39.ProductRepository>()),
    );
    gh.lazySingleton<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        gh<_i259.SignInUseCase>(),
        gh<_i860.SignUpUseCase>(),
        gh<_i787.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i719.OrderRemoteDataSource>(
      () => _i719.OrderRemoteDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
        gh<_i786.AdminNotificationService>(),
      ),
    );
    gh.lazySingleton<_i18.OrderRepository>(
      () => _i292.OrderRepositoryImpl(
        gh<_i719.OrderRemoteDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.factory<_i304.OrderCubit>(
      () => _i304.OrderCubit(
        gh<_i18.OrderRepository>(),
        gh<_i117.AuthCubit>(),
        gh<_i499.CartCubit>(),
        gh<_i44.AnalyticsService>(),
      ),
    );
    gh.lazySingleton<_i513.PaymentCubit>(
      () => _i513.PaymentCubit(
        gh<_i719.OrderRemoteDataSource>(),
        gh<_i499.CartCubit>(),
        gh<_i117.AuthCubit>(),
        gh<_i873.PayMobService>(),
        gh<_i244.SupabaseStorageService>(),
        gh<_i44.AnalyticsService>(),
      ),
    );
    gh.factory<_i802.GetCategoriesUseCase>(
      () => _i802.GetCategoriesUseCase(gh<_i847.CategoryRepository>()),
    );
    gh.factory<_i320.ProductCubit>(
      () => _i320.ProductCubit(gh<_i1035.GetProductsUseCase>()),
    );
    gh.factory<_i369.NotificationCubit>(
      () => _i369.NotificationCubit(
        gh<_i227.NotificationRemoteDataSource>(),
        gh<_i117.AuthCubit>(),
      ),
    );
    gh.factory<_i859.CategoryCubit>(
      () => _i859.CategoryCubit(gh<_i802.GetCategoriesUseCase>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}

class _$SupabaseModule extends _i695.SupabaseModule {}
