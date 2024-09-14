// ignore_for_file: unused_import

import 'package:bai_system/api/model/bai_model/wallet_model.dart';
import 'package:bai_system/representation/about_screen.dart';
import 'package:bai_system/representation/add_bai_screen.dart';
import 'package:bai_system/representation/bai_details.dart';
import 'package:bai_system/representation/feedback.dart';
import 'package:bai_system/representation/fundin_screen.dart';
import 'package:bai_system/representation/history.dart';
import 'package:bai_system/representation/insight.dart';
import 'package:bai_system/representation/intro_screen.dart';
import 'package:bai_system/representation/login.dart';
import 'package:bai_system/representation/me.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:bai_system/representation/no_connection_screen.dart';
import 'package:bai_system/representation/notification_screen.dart';
import 'package:bai_system/representation/payment.dart';
import 'package:bai_system/representation/receipt.dart';
import 'package:bai_system/representation/settings.dart';
import 'package:bai_system/representation/splash_screen.dart';
import 'package:bai_system/representation/support.dart';
import 'package:bai_system/representation/update_profile.dart';
import 'package:bai_system/representation/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../representation/bai_screen.dart';
import 'api/model/bai_model/bai_model.dart';
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
  BaiScreen.routeName: (context) => const BaiScreen(),
  MeScreen.routeName: (context) => const MeScreen(),
  AboutUs.routeName: (context) => const AboutUs(),
  FeedbackScreen.routeName: (context) => const FeedbackScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  AddBai.routeName: (context) => const AddBai(),
  HistoryScreen.routeName: (context) => const HistoryScreen(),
  PaymentScreen.routeName: (context) {
    final agrs = ModalRoute.of(context)!.settings.arguments as CoinPackage;
    return PaymentScreen(
      package: agrs,
    );
  },
  ReceiptScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as WalletModel;

    return ReceiptScreen(
      transaction: args,
    );
  },
  BaiDetails.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as BaiModel;
    return BaiDetails(
      baiModel: args,
    );
  },
  InsightScreen.routeName: (context) => const InsightScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  WalletScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as int?;
    return WalletScreen(
      walletType: args,
    );
  },
  NoInternetScreen.routeName: (context) => const NoInternetScreen(),
  SupportScreen.routeName: (context) => const SupportScreen(),
  SettingScreen.routeName: (context) => const SettingScreen(),
  UpdateProfile.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return UpdateProfile(
      name: args,
    );
  }
};
