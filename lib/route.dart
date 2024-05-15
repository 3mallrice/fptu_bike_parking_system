import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fptu_bike_parking_system/representation/about_screen.dart';
import 'package:fptu_bike_parking_system/representation/add_feedback.dart';
import 'package:fptu_bike_parking_system/representation/feedback.dart';
import 'package:fptu_bike_parking_system/representation/fundin_screen.dart';
import 'package:fptu_bike_parking_system/representation/intro_screen.dart';
import 'package:fptu_bike_parking_system/representation/login.dart';
import 'package:fptu_bike_parking_system/representation/me.dart';
import 'package:fptu_bike_parking_system/representation/navigation_bar.dart';
import 'package:fptu_bike_parking_system/representation/profile.dart';
import 'package:fptu_bike_parking_system/representation/splash_screen.dart';
import 'package:fptu_bike_parking_system/representation/wallet_screen.dart';

import '../representation/bai_screen.dart';
import 'representation/home.dart';

final Map<String, WidgetBuilder> routes = {
  HomeAppScreen.routeName: (context) => const HomeAppScreen(),
  MyNavigationBar.routeName: (context) {
    final agrs = ModalRoute.of(context)!.settings.arguments as int?;
    return MyNavigationBar(
      selectedIndex: agrs ?? 0,
    );
  },
  FundinScreen.routeName: (context) => const FundinScreen(),
  MyWallet.routeName: (context) => const MyWallet(),
  BaiScreen.routeName: (context) => const BaiScreen(),
  MeScreen.routeName: (context) => const MeScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  AboutUs.routeName: (context) => const AboutUs(),
  FeedbackScreen.routeName: (context) => const FeedbackScreen(),
  AddFeedbackScreen.routeName: (context) => const AddFeedbackScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
};
