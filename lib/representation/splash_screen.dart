import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:fptu_bike_parking_system/representation/home.dart';
import 'package:fptu_bike_parking_system/representation/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = '/splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with RestorationMixin {
  @override
  void initState() {
    super.initState();
    //redirectIntro();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  void redirectTo(String redirectTo) {
    Navigator.restorablePushReplacementNamed(context, redirectTo);
    // Navigator.of(context).pushReplacementNamed(redirectTo);
  }

  void redirectIntro() async {
    //await LocalStorageHelper.initLocalStorageHelper(); // Mở Hive box
    final ignoreIntroScreen =
        await LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;
    await Future.delayed(const Duration(milliseconds: 2000));

    if (ignoreIntroScreen != null && ignoreIntroScreen) {
      //redirectTo(Login.routeName);
      redirectTo(HomeAppScreen.routeName);
    } else {
      LocalStorageHelper.setValue('ignoreIntroScreen', true);
      redirectTo(IntroScreen.routeName);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading...'),
        ],
      ),
    ));
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => SplashScreen.routeName;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
  }
}
