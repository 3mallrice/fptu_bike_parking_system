import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/wallet_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/package_service.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/wallet_service.dart';
import 'package:fptu_bike_parking_system/component/shadow_button.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:fptu_bike_parking_system/core/helper/util_helper.dart';
import 'package:fptu_bike_parking_system/representation/payment.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../api/model/bai_model/coin_package_model.dart';
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
  final CallPackageApi _packageApi = CallPackageApi();
  var log = Logger();
  List<CoinPackage> _packages = [];

  void _showPackageDetail(CoinPackage package) {
    showBarModalBottomSheet(
      context: context,
      animationCurve: Curves.easeInCirc,
      barrierColor: Theme.of(context).colorScheme.outline.withOpacity(0.35),
      expand: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 400,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: bottomSheet(package),
            ),
          ),
        );
      },
    );
  }

  Widget bottomSheet(CoinPackage package) {
    return SafeArea(
      child: Column(
        children: [
          AppBar(
            // backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text('Package Detail',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 20,
                    )),
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Package Name:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    package.packageName,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 19,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Price:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${UltilHelper.formatNumber(package.price)}đ',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 19,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Divider(
              color:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.12),
              thickness: 1,
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
                  smallText(
                      context, '  • ${package.amount} bic (Main Wallet).'),
                  if (package.extraCoin != null)
                    smallText(context,
                        '  • ${package.extraCoin} Extra bic (Extra Wallet).'),
                  if (package.extraEXP != null)
                    smallText(context,
                        '  • Your Extra Wallet’s expiration period will increase by ${package.extraEXP} days.'),
                  smallText(
                    context,
                    'Total Coins to Spend: ${int.parse(package.amount) + (package.extraCoin ?? 0)} bic.',
                  ),
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
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  PaymentScreen.routeName,
                  arguments: package,
                );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 60,
                ),
                child: ShadowButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  height: MediaQuery.of(context).size.height * 0.07,
                  buttonTitle:
                      '${UltilHelper.formatNumber(package.price)} VND - BUY NOW',
                  textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),

          // Padding between button and bottom
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          )
        ],
      ),
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

  CallWalletApi callWalletApi = CallWalletApi();
  late int balance = 0;
  late int extraBalance = 0;
  DateTime? expiredDate;
  bool _hideBalance = false;
  bool _isLoading = true;
  String? _error;

  Future<void> _loadHideBalance() async {
    bool? hideBalance =
        await LocalStorageHelper.getValue(LocalStorageKey.isHiddenBalance);
    log.i('Hide balance: $hideBalance');
    setState(() {
      _hideBalance = hideBalance ?? false;
    });
  }

  void _toggleHideBalance() {
    setState(() {
      _hideBalance = !_hideBalance;
      LocalStorageHelper.setValue(
          LocalStorageKey.isHiddenBalance, _hideBalance);
      log.i('Toggle hide balance: $_hideBalance');
    });
  }

  Future<void> getBalance() async {
    try {
      final int? result = await callWalletApi.getMainWalletBalance();
      setState(() {
        balance = result ?? 0;
        log.i('Main wallet balance: $balance');
      });
    } catch (e) {
      log.e('Error during get main wallet balance: $e');
    }
  }

  Future<void> getExtraBalance() async {
    try {
      ExtraBalanceModel? extraBalanceModel =
          await callWalletApi.getExtraWalletBalance();
      if (extraBalanceModel != null) {
        setState(() {
          extraBalance = extraBalanceModel.balance;
          expiredDate = extraBalanceModel.expiredDate;
        });
      }
    } catch (e) {
      log.e('Error during get extra balance: $e');
    }
  }

  Future<void> _loadPackages() async {
    try {
      final packages = await _packageApi.getPackages();
      setState(() {
        _packages = packages ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHideBalance();
    getBalance();
    getExtraBalance();
    _loadPackages();
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
                GestureDetector(
                  onTap: () => _toggleHideBalance(),
                  child: ShadowContainer(
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
                            const SizedBox(width: 30),
                            Text(
                              'BAi Wallet',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          thickness: 1,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current balance:',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              _hideBalance
                                  ? '******'
                                  : 'bic ${UltilHelper.formatNumber(balance)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Extra balance:',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              _hideBalance
                                  ? '******'
                                  : UltilHelper.formatNumber(extraBalance),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        )
                      ],
                    ),
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
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    'AMOUNT(1K = 1.000)',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                _buildPackagesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackagesSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(child: Text('Error: $_error'));
    } else if (_packages.isEmpty) {
      return const Center(child: Text('No packages available'));
    } else {
      return coinPackageGridView(_packages);
    }
  }

  Widget coinPackageGridView(List<CoinPackage> packages) {
    return GridView.builder(
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
                        '${UltilHelper.formatNumber(int.parse(packages[index].amount) + (packages[index].extraCoin ?? 0))} bic',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
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
                              color: Theme.of(context).colorScheme.background,
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
    );
  }
}
