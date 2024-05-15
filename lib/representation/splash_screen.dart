import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:fptu_bike_parking_system/representation/intro_screen.dart';
import 'package:fptu_bike_parking_system/representation/navigation_bar.dart';

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
    redirectIntro();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void redirectTo(String redirectTo) {
    Navigator.restorablePushReplacementNamed(context, redirectTo);
    // Navigator.of(context).pushReplacementNamed(redirectTo);
  }

  void redirectIntro() async {
    final ignoreIntroScreen =
        await LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;
    await Future.delayed(const Duration(milliseconds: 2000));

    if (ignoreIntroScreen != null && ignoreIntroScreen) {
      //redirectTo(Login.routeName);
      redirectTo(MyNavigationBar.routeName);
    } else {
      LocalStorageHelper.setValue('ignoreIntroScreen', true);
      redirectTo(IntroScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(AssetHelper.imgLogo),
            const SizedBox(height: 20),
            Text(
              'Bai',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.w900,
                    fontSize: 50,
                  ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => SplashScreen.routeName;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
  }
}
