import 'dart:io';
import 'dart:typed_data';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

var log = Logger();

Future<bool> widgetToImage(String imageName, Uint8List? image) async {
  try {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      String path = '/storage/emulated/0/Download';

      if (image != null) {
        // Save the image to the device
        File file = File('$path/$imageName.jpg');
        log.i("$path/$imageName.png");
        await file.writeAsBytes(image);

        return true;
      }
    }

    return false;
  } catch (e) {
    log.e(e.toString());
    return false;
  }
}