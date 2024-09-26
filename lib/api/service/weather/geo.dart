import 'package:geolocator/geolocator.dart';

class GeoPermission {
  static Position? _lastKnownPosition;
  static DateTime? _positionCacheTime;

  Future<Position> getCurrentPosition() async {
    if (_lastKnownPosition != null &&
        _positionCacheTime != null &&
        DateTime.now().difference(_positionCacheTime!) <
            const Duration(minutes: 5)) {
      // Sử dụng vị trí từ cache
      return _lastKnownPosition!;
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw Exception('Location permissions are denied');
        }
      }

      _lastKnownPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _positionCacheTime = DateTime.now();
      return _lastKnownPosition!;
    }
  }
}
