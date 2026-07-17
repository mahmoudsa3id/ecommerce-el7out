// core/services/remote_config_service.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';

@lazySingleton
class RemoteConfigService {
  final FirebaseRemoteConfig _config;
  RemoteConfigService(this._config);

  Future<void> init() async {
    await _config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _config.setDefaults({
      AppConstants.remoteConfigSaleEnabled: false,
      AppConstants.remoteConfigFreeShippingThreshold: 150.0,
      AppConstants.remoteConfigFeaturedCategory: 'new-arrivals',
    });
    await _config.fetchAndActivate();
  }

  bool get saleEnabled => _config.getBool(AppConstants.remoteConfigSaleEnabled);

  double get freeShippingThreshold =>
      _config.getDouble(AppConstants.remoteConfigFreeShippingThreshold);

  String get featuredCategory =>
      _config.getString(AppConstants.remoteConfigFeaturedCategory);
}
