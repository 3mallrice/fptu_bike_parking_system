import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/wallet_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/wallet_service.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:fptu_bike_parking_system/representation/fundin_screen.dart';
import 'package:fptu_bike_parking_system/representation/navigation_bar.dart';
import 'package:fptu_bike_parking_system/representation/wallet_screen.dart';
import 'package:logger/logger.dart';
import 'package:transition/transition.dart';

import '../core/helper/util_helper.dart';

class WalletExtraScreen extends StatefulWidget {
  const WalletExtraScreen({super.key});

  static String routeName = '/my_extra_wallet';

  @override
  State<WalletExtraScreen> createState() => _WalletExtraScreenState();
}

class _WalletExtraScreenState extends State<WalletExtraScreen> {
  bool _hideBalance = false;
  var log = Logger();
  CallWalletApi callWalletApi = CallWalletApi();
  late int extraBalance = 0;
  DateTime? expiredDate;
  List<WalletModel> transactions = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> _loadHideBalance() async {
    bool? hideBalance =
        await LocalStorageHelper.getValue(LocalStorageKey.isHiddenBalance);
    log.i('Hide balance: $hideBalance');
    setState(() {
      _hideBalance = hideBalance ?? false;
    });
  }

  void _toggleHideBalance() async {
    setState(() {
      log.i('Toggle hide balance: $_hideBalance');
      _hideBalance = !_hideBalance;
    });
    // await LocalStorageHelper.setValue('hide_balance', _hideBalance);
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

  Future<void> getExtraTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final List<WalletModel>? result =
          await callWalletApi.getExtraWalletTransactions();
      setState(() {
        transactions = result ?? [];
      });
    } catch (e) {
      log.e('Error during get extra wallet transactions: $e');
      setState(() {
        errorMessage = 'Error loading data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHideBalance();
    getExtraBalance();
    getExtraTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCom(
        leading: true,
        routeName: MyNavigationBar.routeName,
        appBarText: 'Wallet',
        action: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(FundinScreen.routeName),
              icon: Icon(
                Icons.input_rounded,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 20, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        Transition(
                          child: const MyWallet(),
                          transitionEffect: TransitionEffect.LEFT_TO_RIGHT,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: ShadowContainer(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: Text(
                          'Main',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ShadowContainer(
                      width: MediaQuery.of(context).size.width * 0.43,
                      color: Theme.of(context).colorScheme.outline,
                      child: Text(
                        'Extra',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: ShadowContainer(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: GestureDetector(
                    onTap: () => _toggleHideBalance(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Extra coin',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          _hideBalance
                              ? '******'
                              : '${UltilHelper.formatNumber(extraBalance)} bic',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          expiredDate != null
                              ? '${UltilHelper.formatNumber(extraBalance)} bic will expire on ${UltilHelper.formatDate(expiredDate!)}'
                              : '${UltilHelper.formatNumber(extraBalance)} bic',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 10,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                color: Theme.of(context).colorScheme.secondary,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HISTORIES',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        Text(
                          'FILTER',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            //TODO: Open filter dialog
                          },
                          child: Icon(
                            Icons.filter_list_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 20,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              // List of transaction
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(
                          child: Text(
                            errorMessage!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : transactions.isEmpty
                          ? Center(
                              child: Text(
                                'No transaction found',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                Color itemBackgroundColor = index % 2 == 0
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.secondary;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    color: itemBackgroundColor,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: transactions[index]
                                                    .transactionType ==
                                                'IN'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline,
                                        child: Icon(
                                          transactions[index].transactionType ==
                                                  'IN'
                                              ? Icons.attach_money_rounded
                                              : Icons.local_parking_rounded,
                                        ),
                                      ),
                                      title: Text(
                                        transactions[index].transactionType ==
                                                'IN'
                                            ? 'Deposit'
                                            : 'Parking Fee',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transactions[index]
                                                    .transactionDescription ??
                                                '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          Text(
                                            UltilHelper.formatDate(
                                                transactions[index].date),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                ),
                                          )
                                        ],
                                      ),
                                      trailing: Text(
                                        (transactions[index].transactionType ==
                                                    'IN'
                                                ? '+'
                                                : '-') +
                                            UltilHelper.formatNumber(
                                                transactions[index].amount),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
