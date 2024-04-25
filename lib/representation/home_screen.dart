import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/helper/firebase_image_storage_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';

import 'navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = '/fake';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? imageUrl;
  var log = Logger();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MainAppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MyNavigationBar.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Click me',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(HomeAppScreen.routeName);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Theme.of(context).colorScheme.primary,
            //   ),
            //   child: Text(
            //     'Next to home real',
            //     style: Theme.of(context).textTheme.labelMedium,
            //   ),
            // ),
            IconButton(
              onPressed: () async {
                //let user choose image from gallery or camera
                ImageSource? source = await showSourceDialog(context);

                //step 1: pick image
                //install image_picker package
                ImagePicker imagePicker = ImagePicker();
                XFile? file = await imagePicker.pickImage(
                    source: source ?? ImageSource.gallery);

                log.i('Image path: ${file?.path}');

                //check if user cancel pick image
                if (file == null) {
                  return;
                }

                //step 2: upload image to firebase storage
                FirebaseImageStorageHelper storageHelper =
                    FirebaseImageStorageHelper();
                String? url = await storageHelper.uploadImage(
                  file,
                  storageHelper.avatarFoler,
                );
                //step 3: get image url
                setState(() {
                  imageUrl = url;
                  log.i('Image url: $imageUrl');
                });

                //step 4: display image
              },
              icon: const Icon(Icons.camera_alt),
            ),
            Text(
              imageUrl ?? 'No image',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: Image.network(
                imageUrl?.toString() ?? 'https://via.placeholder.com/200',
                fit: BoxFit.fitHeight,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('No image available');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<ImageSource?> showSourceDialog(BuildContext context) async {
    return showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose image source'),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_rounded),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }
}
