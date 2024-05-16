import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/shadow_button.dart';
import 'package:fptu_bike_parking_system/representation/payos.dart';

import '../component/app_bar_component.dart';
import '../component/shadow_container.dart';
import '../core/helper/asset_helper.dart';
import 'wallet_screen.dart';

class FundinScreen extends StatefulWidget {
  const FundinScreen({super.key});

  static String routeName = '/fundin_screen';

  @override
  State<FundinScreen> createState() => _FundinScreenState();
}

class _FundinScreenState extends State<FundinScreen> {
  final List<String> num1 = [
    '20.000',
    '50.000',
    '100.000',
    '200.000',
    '500.000'
  ];

  final List<String> num2 = [
    '20.000',
    '50.000',
    '97.000',
    '194.000',
    '485.000'
  ];

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
                color: Theme.of(context).colorScheme.onSecondary,
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
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'BAI Wallet',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current balance: ',
                            style: Theme.of(context).textTheme.bodyLarge,
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
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'PROVIDER',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                ShadowContainer(
                  child: Image(
                    image: const AssetImage(AssetHelper.baiLogo),
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'AMOUNT',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 11,
                  ),
                  itemCount: num1.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        //kkk
                      },
                      child: ShadowContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                num1[index],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Price: ${num2[index]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      'By tapping CONFIRM you agree to deposit bai coins into your wallet.',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(PayOsScreen.routeName);
                  },
                  child: const ShadowButton(
                    buttonTitle: 'CONFIRM',
                    margin: EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
