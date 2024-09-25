import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = 'customCache';

  static CustomCacheManager? _instance;

  factory CustomCacheManager() {
    _instance ??= CustomCacheManager._();
    return _instance!;
  }

  CustomCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(minutes: 30), // cache 30p
            maxNrOfCacheObjects: 20,
          ),
        );
}
