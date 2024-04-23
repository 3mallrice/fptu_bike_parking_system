import 'package:flutter/material.dart';
import 'representation/home.dart';
import 'representation/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(), //fake
  HomeAppScreen.routeName: (context) => const HomeAppScreen(),
};
