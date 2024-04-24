import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class FirebaseImageStorageHelper {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var log = Logger();

  final String avatarFoler = 'avatars';
  final String bannerFolder = 'banners';

  Future<String?> uploadImage(XFile imageFile, String folderName) async {
    //imageName = avatars(banners)/imageName
    try {
      //Generate unique imageName
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the location where you want to upload the file
      Reference ref = _storage.ref().child('imgs/$folderName/$imageName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(File(imageFile.path));

      // Get the download URL of the uploaded file
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      log.i('Uploading image successfully: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      log.e('Error uploading image: $e');
      return null;
    }
  }

  ///Still not tested
  Future<File?> downloadImage(String imageUrl, String savePath) async {
    try {
      // Create a reference to the file you want to download
      Reference ref = _storage.refFromURL(imageUrl);

      // Download the file to the specified path on the device
      File file = File(savePath);
      await ref.writeToFile(file);

      log.i('Downloading image successfully: $savePath');

      return file;
    } catch (e) {
      log.e('Error downloading image: $e');
      return null;
    }
  }
}
