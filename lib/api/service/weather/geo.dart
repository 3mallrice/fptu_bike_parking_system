import 'package:geolocator/geolocator.dart';

class GeoPermission {
  Future<void> checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }
}
