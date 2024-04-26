import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';

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
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 130),
                  child: ImageSlideshow(
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    indicatorBottomPadding: 45,
                    indicatorRadius: 4,
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
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.width * 0.025,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Image(
                            image: AssetImage(AssetHelper.bic),
                            fit: BoxFit.fitWidth,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              '45.000 bic',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.input_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Fund in',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.history_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'History',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      //report
                                      Icons.insert_chart_outlined_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Report',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.motorcycle_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Bais',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.width * 0.025,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage(AssetHelper.imgLogo),
                          fit: BoxFit.fitWidth,
                          width: 60,
                        ),
                        Text(
                          'Bai Parking',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Image(
                      image: AssetImage(AssetHelper.bai),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.width * 0.025,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            )
          ],
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
