import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/representation/wallet_screen.dart';

import '../core/helper/asset_helper.dart';

class FundinScreen extends StatefulWidget {
  const FundinScreen({super.key});

  static String routeName = '/fundin_screen';
  @override
  State<FundinScreen> createState() => _FundinScreenState();
}

class _FundinScreenState extends State<FundinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCom(
        leading: true,
        appBarText: 'Fund in',
        action: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(MyWallet.routeName),
              icon: Icon(
                Icons.wallet,
                color: Theme.of(context).colorScheme.outline,
              ),
              iconSize: 21,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadowContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'TO',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'BAI Wallet',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.onTertiary,
                        thickness: 0.5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current balance: ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: [
                              const Image(
                                image: AssetImage(AssetHelper.bic),
                                fit: BoxFit.fitWidth,
                                width: 25,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '45.000 bic',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'PROVIDER',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ShadowContainer(
                  child: Image(
                    image: const AssetImage(AssetHelper.baiLogo),
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'AMOUNT',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    primary: false,
                    children: [
                      ShadowContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '20.000 bic',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Price: 20.000',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      ShadowContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '50.000 bic',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Price: 50.000',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      ShadowContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '100.000 bic',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Price: 97.000',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      ShadowContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '200.000 bic',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Price: 194.000',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      ShadowContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '500.000 bic',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Price: 485.000',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
