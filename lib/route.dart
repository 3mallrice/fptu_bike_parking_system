import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fptu_bike_parking_system/representation/about_screen.dart';
import 'package:fptu_bike_parking_system/representation/add_bai_screen.dart';
import 'package:fptu_bike_parking_system/representation/add_feedback.dart';
import 'package:fptu_bike_parking_system/representation/feedback.dart';
import 'package:fptu_bike_parking_system/representation/fundin_screen.dart';
import 'package:fptu_bike_parking_system/representation/history.dart';
import 'package:fptu_bike_parking_system/representation/insight.dart';
import 'package:fptu_bike_parking_system/representation/intro_screen.dart';
import 'package:fptu_bike_parking_system/representation/login.dart';
import 'package:fptu_bike_parking_system/representation/me.dart';
import 'package:fptu_bike_parking_system/representation/navigation_bar.dart';
import 'package:fptu_bike_parking_system/representation/payment.dart';
import 'package:fptu_bike_parking_system/representation/payos.dart';
import 'package:fptu_bike_parking_system/representation/profile.dart';
import 'package:fptu_bike_parking_system/representation/receipt.dart';
import 'package:fptu_bike_parking_system/representation/splash_screen.dart';
import 'package:fptu_bike_parking_system/representation/wallet_extra_screen.dart';
import 'package:fptu_bike_parking_system/representation/wallet_screen.dart';

import '../representation/bai_screen.dart';
import 'api/model/bai_model/coin_package_model.dart';
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
  AddBai.routeName: (context) => const AddBai(),
  PayOsScreen.routeName: (context) => const PayOsScreen(),
  HistoryScreen.routeName: (context) => const HistoryScreen(),
  WalletExtraScreen.routeName: (context) => const WalletExtraScreen(),
  PaymentScreen.routeName: (context) {
    final agrs = ModalRoute.of(context)!.settings.arguments as CoinPackage;
    return PaymentScreen(
      package: agrs,
    );
  },
  ReceiptScreen.routeName: (context) => const ReceiptScreen(),
  InsightScreen.routeName: (context) => const InsightScreen(),
};
