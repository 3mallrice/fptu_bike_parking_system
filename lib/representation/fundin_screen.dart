import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/shadow_button.dart';
import 'package:fptu_bike_parking_system/representation/payos.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  final List<CoinPackage> packages = [
    CoinPackage(
      packageName: 'Basic Package',
      amount: 10000,
      price: 10000,
      extraCoin: 1000,
      extraEXP: 10,
    ),
    CoinPackage(
      packageName: 'Standard Package',
      amount: 20000,
      price: 20000,
      extraCoin: 2000,
      extraEXP: 20,
    ),
    CoinPackage(
      packageName: 'Premium Package',
      amount: 50000,
      price: 50000,
      extraCoin: 5000,
      extraEXP: 50,
    ),
    CoinPackage(
      packageName: 'VIP Package',
      amount: 100000,
      price: 100000,
      extraCoin: 10000,
      extraEXP: 100,
    ),
    CoinPackage(
      packageName: 'Platinum Package',
      amount: 200000,
      price: 200000,
      extraCoin: 20000,
      extraEXP: null,
    ),
    CoinPackage(
      packageName: 'Diamond Package',
      amount: 500000,
      price: 500000,
      extraCoin: 50000,
      extraEXP: null,
    ),
  ];

  void _showPackageDetail(CoinPackage package) {
    showBarModalBottomSheet(
      context: context,
      animationCurve: Curves.easeInCirc,
      barrierColor: Theme.of(context).colorScheme.outline.withOpacity(0.35),
      expand: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      closeProgressThreshold: 0.3,
      enableDrag: true,
      elevation: 4,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.5;
        final minHeight = MediaQuery.of(context).size.height * 0.2;

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxHeight: maxHeight,
          ),
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              middle: Text(
                'Package Detail',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.background,
                    ),
              ),
              automaticallyImplyLeading: false,
              border: const Border(
                bottom: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          package.packageName,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            smallText(context,
                                'If you purchase the ${package.packageName}, you will get:'),
                            smallText(context,
                                '  • ${package.amount} bic (Main Wallet).'),
                            if (package.extraCoin != null)
                              smallText(context,
                                  '  • ${package.extraCoin} Extra bic (Extra Wallet).'),
                            if (package.extraEXP != null)
                              smallText(context,
                                  '  • Your Extra Wallet’s expiration period will increase by ${package.extraEXP} days.'),
                            smallText(context,
                                'Total Coins to Spend: ${package.amount + (package.extraCoin ?? 0)} bic.'),
                            if (package.extraEXP != null)
                              smallText(context,
                                  'Expiration Extension: +${package.extraEXP} days added to the current expiration date of your Extra Wallet coins.'),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Keep in mind:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            smallText(context,
                                'Each purchase extends the expiration of all your extra coins by the specified days, giving you more flexibility to use them.'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            'By tapping BUY NOW you agree to deposit bai coins into your wallet.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PayOsScreen.routeName);
                        },
                        child: ShadowButton(
                          backgroundColor:
                              Theme.of(context).colorScheme.outline,
                          height: MediaQuery.of(context).size.height * 0.07,
                          buttonTitle: '${package.price} VND - BUY NOW',
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget smallText(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.left,
      ),
    );
  }

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
                  height: 35,
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
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    'AMOUNT(1K = 1.000)',
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
                  itemCount: packages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => _showPackageDetail(packages[index]),
                      child: ShadowContainer(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.1,
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${packages[index].amount + (packages[index].extraCoin ?? 0)} bic',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  if (packages[index].extraEXP != null)
                                    Text(
                                      '+${packages[index].extraEXP} days',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(fontSize: 12),
                                      textAlign: TextAlign.left,
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${packages[index].price ~/ 1000}K\nVND',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CoinPackage {
  final String packageName;
  final int amount;
  final int price;
  final int? extraCoin;
  final int? extraEXP;

  CoinPackage({
    required this.packageName,
    required this.amount,
    required this.price,
    this.extraCoin,
    this.extraEXP,
  });
}
