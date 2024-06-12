import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  static const String routeName = '/payment_screen';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Payment',
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(AssetHelper.baiLogo),
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'ID: Copy',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              ShadowContainer(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pending,
                            color: Theme.of(context).colorScheme.background,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Pending transaction',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Move Money',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '19/05/2024 08:20',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '80.000',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'bic',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w900,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DottedLine(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              lineLength: double.infinity,
                              lineThickness: 1.0,
                              dashColor: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Table(
                              columnWidths: const {
                                0: FractionColumnWidth(0.25) // Cột đầu tiên
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Text(
                                      'Type',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Fund In',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Text(
                                      'Message',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Fund in via existing package',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select your payment options',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              ShadowContainer(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Image(
                      image: AssetImage(AssetHelper.zaloLogo),
                      height: 20,
                      fit: BoxFit.fitHeight,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ShadowContainer(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.qr_code,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
