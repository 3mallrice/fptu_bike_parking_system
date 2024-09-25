import 'package:geolocator/geolocator.dart';

class GeoPermission {
  static Position? _lastKnownPosition;
  static DateTime? _positionCacheTime;

  Future<Position> getCurrentPosition() async {
    if (_lastKnownPosition != null &&
        _positionCacheTime != null &&
        DateTime.now().difference(_positionCacheTime!) <
            const Duration(minutes: 5)) {
      // Sử dụng vị trí trong cache
      return _lastKnownPosition!;
    } else {
      // Check và request location permission
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }

      // Lấy vị trí hiện tại
      _lastKnownPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _positionCacheTime = DateTime.now();
      return _lastKnownPosition!;
    }
  }
}
