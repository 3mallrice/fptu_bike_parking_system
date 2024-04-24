import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/core/helper/firebase_storage_helper.dart';
import 'package:fptu_bike_parking_system/representation/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

import '../core/theme/theme_provider.dart';

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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarCom(
        leading: false,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // change dark/light here
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Click me',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(HomeAppScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Next to home real',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
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
                FirebaseStorageHelper storageHelper = FirebaseStorageHelper();
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
