import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:dotted_line/dotted_line.dart';

import '../component/shadow_container.dart';

class HistoryScreen extends StatefulWidget {
  static String routeName = '/history_screen';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var log = Logger();
  //init History list
  List<History> historyList = [
    History(
      parkingArea: 'Central Plaza Parking Lot',
      plateNumber: '29A-12345',
      timeIn: DateTime(2024, 5, 10, 11, 30),
      timeOut: DateTime(2024, 5, 10, 15, 45),
      gateIn: 'A1',
      gateOut: 'A2',
      paymentMethod: 'Cash',
      amount: '10.000',
    ),
    History(
      parkingArea: 'Riverside Bike Dock',
      plateNumber: '29A-54321',
      timeIn: DateTime(2024, 5, 12, 10, 30),
      timeOut: DateTime(2024, 5, 12, 12, 45),
      gateIn: 'Entrance',
      gateOut: 'Exit',
      paymentMethod: 'Wallet',
      amount: '10.000',
    ),
    History(
      parkingArea: 'Green Park Bike Station',
      plateNumber: '29A-67890',
      timeIn: DateTime(2024, 5, 15, 6, 30),
      timeOut: DateTime(2024, 5, 15, 8, 45),
      gateIn: 'C1',
      gateOut: 'C2',
      paymentMethod: 'Wallet',
      amount: '10.000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                ShadowContainer(
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
                              'Total Parking frequency',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '3',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // TODO: implement fliter dialog
                            },
                            icon: const Icon(
                              Icons.filter_list_rounded,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                //History list
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: historyList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ShadowContainer(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 40,
                          ),
                          child: Column(
                            children: [
                              Text(
                                historyList[index].parkingArea,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: DottedLine(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashColor:
                                      Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              Text(
                                historyList[index].plateNumber,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        historyInfo(
                                          'Time in:',
                                          DateFormat('dd/MM/yyyy HH:mm').format(
                                              historyList[index].timeIn),
                                        ),
                                        const SizedBox(height: 10),
                                        historyInfo(
                                          'Time out:',
                                          DateFormat('dd/MM/yyyy HH:mm').format(
                                              historyList[index].timeOut),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        historyInfo(
                                          'Gate in:',
                                          historyList[index].gateIn.toString(),
                                        ),
                                        const SizedBox(height: 10),
                                        historyInfo(
                                          'Gate out:',
                                          historyList[index].gateOut.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: DottedLine(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashColor:
                                      Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.share_rounded),
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          historyList[index]
                                              .paymentMethod
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AssetHelper.bic,
                                              width: 25,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${historyList[index].amount.toString()} bic',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
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

  Widget historyInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }
}

class History {
  final String parkingArea;
  final String plateNumber;
  final DateTime timeIn;
  final DateTime timeOut;
  final String gateIn;
  final String gateOut;
  final String paymentMethod;
  final String amount;

  History({
    required this.parkingArea,
    required this.plateNumber,
    required this.timeIn,
    required this.timeOut,
    required this.gateIn,
    required this.gateOut,
    required this.paymentMethod,
    required this.amount,
  });
}
