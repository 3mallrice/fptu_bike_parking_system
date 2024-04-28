import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../component/main_app_bar.dart';
import '../core/helper/asset_helper.dart';
import 'history.dart';
import 'home.dart';
import 'me.dart';
import 'vehicle.dart';

class MyNavigationBar extends StatefulWidget {
  static const String routeName = '/navigation_bar';
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeAppScreen(),
    VehicleScreen(),
    HistoryScreen(),
    MeScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: const MainAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 25,
          iconStyle: IconStyle.Default,
          barAnimation: BarAnimation.blink,
          inkColor: Theme.of(context).colorScheme.primary,
          opacity: 0.5,
        ),
        elevation: 5,
        backgroundColor: Theme.of(context).colorScheme.background,
        currentIndex: _selectedIndex,
        iconSpace: 10,
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_rounded),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          BottomBarItem(
            icon: const Icon(Icons.motorcycle_rounded),
            title: Text(
              'Bai',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          BottomBarItem(
            icon: const Icon(Icons.history_rounded),
            title: Text(
              'History',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_2_rounded),
            title: Text(
              'Me',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
        ],
        notchStyle: NotchStyle.square,
        onTap: _onItemTapped,
      ),
    );
  }
}
