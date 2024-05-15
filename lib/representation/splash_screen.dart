import 'package:flutter/material.dart';

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
      redirectTo(Login.routeName);
    } else {
      LocalStorageHelper.setValue('ignoreIntroScreen', true);
      redirectTo(IntroScreen.routeName);
    }
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
