import 'dart:io';
import 'dart:typed_data';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

var log = Logger();

Future<bool> saveImage(String imageName, Uint8List? image) async {
  try {
    var status = await Permission.photos.request();

    if (status == PermissionStatus.granted) {
      String path = '/storage/emulated/0/Download';

      if (image != null) {
        // Save the image to the device
        File file = File('$path/$imageName.jpg');
        log.i("$path/$imageName.png");
        await file.writeAsBytes(image);

        return true;
      }
    } else if (status.isDenied) {
      var newStatus = await Permission.storage.request();

      if (newStatus.isGranted) {
      } else if (newStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  } catch (e) {
    log.e(e.toString());
    return false;
  }
}
