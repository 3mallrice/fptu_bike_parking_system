import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class HomeAppScreen extends StatefulWidget {
  const HomeAppScreen({super.key});

  static String routeName = '/home_screen';

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ImageSlideshow(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.27,
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    indicatorBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    initialPage: 0,
                    indicatorPadding: 5,
                    autoPlayInterval: 5000,
                    isLoop: true,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner1,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            height: 139,
                            image: AssetImage(
                              AssetHelper.banner1,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner2,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            height: 139,
                            image: AssetImage(
                              AssetHelper.banner2,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner3,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            height: 139,
                            image: AssetImage(
                              AssetHelper.banner3,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner4,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            height: 139,
                            image: AssetImage(
                              AssetHelper.banner4,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner5,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            height: 139,
                            image: AssetImage(
                              AssetHelper.banner5,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenImageDialog extends StatelessWidget {
  final String imagePath;

  const FullScreenImageDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
