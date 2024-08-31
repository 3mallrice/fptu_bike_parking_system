import 'package:bai_system/representation/bai_screen.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../component/main_app_bar.dart';
import 'history.dart';
import 'home.dart';
import 'me.dart';

class MyNavigationBar extends StatefulWidget {
  static const String routeName = '/navigation_bar';

  final int? selectedIndex;

  const MyNavigationBar({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex!;
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeAppScreen(),
    BaiScreen(),
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
      body: PopScope(
        canPop: false,
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 25,
          iconStyle: IconStyle.Default,
          barAnimation: BarAnimation.blink,
          inkColor: Theme.of(context).colorScheme.primary,
          opacity: 0.5,
        ),

        // elevation: 5,
        backgroundColor: Theme.of(context).colorScheme.surface,
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
            icon: const Icon(Icons.dehaze_rounded),
            title: Text(
              'Others',
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
