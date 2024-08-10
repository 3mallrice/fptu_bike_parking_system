import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/wallet_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/wallet_service.dart';
import 'package:fptu_bike_parking_system/component/loading_component.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:fptu_bike_parking_system/representation/receipt.dart';
import 'package:fptu_bike_parking_system/representation/wallet_extra_screen.dart';
import 'package:logger/logger.dart';
import 'package:transition/transition.dart';

import '../component/app_bar_component.dart';
import '../component/return_login_component.dart';
import '../component/shadow_container.dart';
import '../core/const/frondend/message.dart';
import '../core/helper/local_storage_helper.dart';
import 'fundin_screen.dart';
import 'navigation_bar.dart';

class MyWallet extends StatefulWidget {
  static String routeName = '/my_wallet';

  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool _hideBalance = false;
  var log = Logger();
  CallWalletApi callWalletApi = CallWalletApi();
  late int balance = 0;
  List<WalletModel> transactions = [];
  bool isLoading = true;
  String? errorMessage;

  //return login dialog
  void returnLoginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const InvalidTokenDialog();
      },
    );
  }

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

  Future<void> getBalance() async {
    try {
      final APIResponse<int> result =
          await callWalletApi.getMainWalletBalance();

      if (result.isTokenValid == false &&
          result.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show error dialog
        returnLoginDialog();
        return;
      }

      setState(() {
        balance = result.data ?? 0;
        log.i('Main wallet balance: $balance');
      });
    } catch (e) {
      log.e('Error during get main wallet balance: $e');
    }
  }

  Future<void> getMainTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final APIResponse<List<WalletModel>> result =
          await callWalletApi.getMainWalletTransactions();

      if (result.isTokenValid == false &&
          result.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show error dialog
        returnLoginDialog();
        return;
      }
      setState(() {
        transactions = result.data ?? [];
      });
    } catch (e) {
      log.e('Error during get main wallet transactions: $e');
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
    getBalance();
    getMainTransactions();
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
                    ShadowContainer(
                      width: MediaQuery.of(context).size.width * 0.43,
                      color: Theme.of(context).colorScheme.outline,
                      child: Text(
                        'Main',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        Transition(
                          child: const WalletExtraScreen(),
                          transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: ShadowContainer(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: Text(
                          'Extra',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
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
                          'Current balance',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          _hideBalance
                              ? '******'
                              : '${UltilHelper.formatMoney(balance)} bic',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
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
                  ? const LoadingCircle()
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
                                return GestureDetector(
                                  onTap: () {
                                    //Open receipt screen
                                    Navigator.of(context).pushNamed(
                                      ReceiptScreen.routeName,
                                      arguments: transactions[index],
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      color: itemBackgroundColor,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              transactions[index].type == 'IN'
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                          child: Icon(
                                            transactions[index].type == 'IN'
                                                ? Icons.attach_money_rounded
                                                : Icons.local_parking_rounded,
                                          ),
                                        ),
                                        title: Text(
                                          transactions[index].type == 'IN'
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
                                              transactions[index].description ??
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
                                          (transactions[index].type == 'IN'
                                                  ? '+'
                                                  : '-') +
                                              UltilHelper.formatMoney(
                                                  transactions[index].amount),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
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
