import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../component/app_bar_component.dart';
import '../component/shadow_container.dart';
import '../core/helper/local_storage_helper.dart';
import 'fundin_screen.dart';

class MyWallet extends StatefulWidget {
  static String routeName = '/my_wallet';

  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool _hideBalance = false;
  var log = Logger();

  Future<void> _loadHideBalance() async {
    bool? hideBalance = await LocalStorageHelper.getValue('hide_balance');
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

  // Function to check if a date is today
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Function to check if a date is yesterday
  bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Function to format date
  String formatDate(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  //init transaction list
  List<TransactionList> transactionList = [
    TransactionList(
      date: DateTime.now(),
      transactionList: [
        TransactionItem(
          title: 'Deposit',
          amount: '100.000',
          transactionType: true,
        ),
        TransactionItem(
          title: 'Parking Fee',
          amount: '50.000',
          transactionType: false,
        ),
      ],
    ),
    TransactionList(
      //date in format dd/mm/yyyy
      date: DateTime(2024, 5, 13),
      transactionList: [
        TransactionItem(
          title: 'Deposit',
          amount: '100.000',
          transactionType: true,
        ),
        TransactionItem(
          title: 'Parking Fee',
          amount: '50.000',
          transactionType: false,
        ),
      ],
    ),
    TransactionList(
      date: DateTime(2024, 5, 12),
      transactionList: [
        TransactionItem(
          title: 'Deposit',
          amount: '100.000',
          transactionType: true,
        ),
        TransactionItem(
          title: 'Deposit',
          amount: '50.000',
          transactionType: true,
        ),
      ],
    ),
  ];

  @override
  initState() {
    super.initState();
    _loadHideBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCom(
        leading: true,
        appBarText: 'Wallet',
        action: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                            _hideBalance ? '******' : '45.000 bic',
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

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'WALLET HISTORY',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            'FILTER',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactionList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            color: Theme.of(context).colorScheme.secondary,
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 1,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                child: Text(
                                  formatDate(transactionList[index].date),
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
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  transactionList[index].transactionList.length,
                              itemBuilder: (context, i) {
                                bool transactionType = transactionList[index]
                                    .transactionList[i]
                                    .transactionType;

                                String title = transactionList[index]
                                    .transactionList[i]
                                    .title;

                                String amount = transactionList[index]
                                    .transactionList[i]
                                    .amount;

                                return Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: transactionType
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                              ),
                                        ),
                                        Text(
                                          '${transactionType ? '' : '-'} bic $amount',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: transactionType
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
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

class TransactionItem {
  final String title;
  final String amount;
  final bool transactionType;

  TransactionItem({
    required this.title,
    required this.amount,
    this.transactionType = true,
  });
}

class TransactionList {
  final DateTime date;
  final List<TransactionItem> transactionList;

  TransactionList({
    required this.date,
    required this.transactionList,
  });
}
