import 'package:flutter/material.dart';

class ExceptionScreen extends StatefulWidget {
  const ExceptionScreen({super.key});

  static String routeName = '/exception_screen';

  @override
  State<ExceptionScreen> createState() => _ExceptionScreenState();
}

class _ExceptionScreenState extends State<ExceptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.outline,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Icon(
                        Icons.link_off_rounded,
                        size: 40,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No connection',
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontSize: 26,
                                ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'It appears your device is not connected to a network. If you wish to perform an action, please try to reconnect.',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'OK',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.background,
              ),
        ),
      ),
    );
  }
}
