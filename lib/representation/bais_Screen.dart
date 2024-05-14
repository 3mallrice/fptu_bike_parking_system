import 'package:flutter/material.dart';

class BaisScreen extends StatefulWidget {
  const BaisScreen({super.key});

  static String routeName = '/bais_screen';

  @override
  State<BaisScreen> createState() => _BaisScreenState();
}

class _BaisScreenState extends State<BaisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total bikes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '2',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  //kkk
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.add_rounded,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
