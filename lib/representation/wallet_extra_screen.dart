import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:fptu_bike_parking_system/representation/fundin_screen.dart';
import 'package:fptu_bike_parking_system/representation/home.dart';
import 'package:fptu_bike_parking_system/representation/wallet_screen.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:transition/transition.dart';

class WalletExtraScreen extends StatefulWidget {
  const WalletExtraScreen({super.key});

  static String routeName = '/my_extra_wallet';

  @override
  State<WalletExtraScreen> createState() => _WalletExtraScreenState();
}

class _WalletExtraScreenState extends State<WalletExtraScreen> {
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

  @override
  initState() {
    super.initState();
    _loadHideBalance();
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
            description: 'Deposit from bank',
            total: '100.000'),
        TransactionItem(
            title: 'Parking Fee',
            amount: '50.000',
            transactionType: false,
            description: 'Deposit from bank',
            total: '500.000'),
      ],
    ),
    TransactionList(
      //date in format dd/mm/yyyy
      date: DateTime(2024, 6, 10),
      transactionList: [
        TransactionItem(
            title: 'Deposit',
            amount: '100.000',
            transactionType: true,
            description: 'Deposit from bank',
            total: '100.000'),
        TransactionItem(
            title: 'Parking Fee',
            amount: '50.000',
            transactionType: false,
            description: 'Deposit from bank',
            total: '500.000'),
      ],
    ),
    TransactionList(
      date: DateTime(2024, 5, 12),
      transactionList: [
        TransactionItem(
            title: 'Deposit',
            amount: '100.000',
            transactionType: true,
            description: 'Deposit from bank',
            total: '100.000'),
        TransactionItem(
            title: 'Parking Fee',
            amount: '50.000',
            transactionType: false,
            description: 'Deposit from bank',
            total: '500.000'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCom(
        leading: true,
        routeName: HomeAppScreen.routeName,
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
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.background,
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
                          _hideBalance ? '******' : '5.000 bic',
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
                          '5.000 bic will expire on 20/06/2024',
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

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
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

                              String description = transactionList[index]
                                  .transactionList[i]
                                  .description;

                              String extra = transactionList[index]
                                  .transactionList[i]
                                  .total;

                              return Container(
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
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                description,
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${transactionType ? '' : '-'} bic $amount',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                extra,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: transactionType
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .primary
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .outline,
                                                    ),
                                              )
                                            ],
                                          ),
                                        ],
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
    );
  }
}

class TransactionItem {
  final String title;
  final String amount;
  final bool transactionType;
  final String description;
  final String total;

  TransactionItem({
    required this.description,
    required this.total,
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
