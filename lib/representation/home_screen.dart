import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // change theme here
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: SizedBox(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Click me',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
