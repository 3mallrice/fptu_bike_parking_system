import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static String routeName = '/intro_screen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        autoScrollDuration: 3000,
        infiniteAutoScroll: true,
        pages: [
          PageViewModel(
            title: "FPTU Bike Parking System",
            body: "A smart and modern parking management system.",
            image: Image.asset(AssetHelper.splash),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Welcome!",
            body:
                "This app is simplest way to pay your parking using your smartphone only.",
            image: Image.asset(AssetHelper.splash),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Lest's get started!",
            body: "Easy to pay, easy to manage, easy to use.",
            image: Image.asset(AssetHelper.splash),
            decoration: pageDecoration,
          ),
        ],
      ),
    );
  }
}
