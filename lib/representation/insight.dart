import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/how_did_you_park.dart';
import 'package:fptu_bike_parking_system/component/how_did_you_pay.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';

import '../api/model/bai_model/chart.dart';
import '../component/how_did_you_spent.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  static String routeName = '/insight_screen';

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  //fake data for testing
  // HowDidYouPark
  // Dữ liệu thử nghiệm với sự thay đổi không đều
  List<HowDidYouParkAndSpend> howDidYouParkList = [
    HowDidYouParkAndSpend(
      date: DateTime.now(),
      numberOfParkings: 10,
      amount: 100000,
    ),
    HowDidYouParkAndSpend(
      date: DateTime.now().add(const Duration(days: 1)),
      numberOfParkings: 15,
      amount: 150000,
    ),
    HowDidYouParkAndSpend(
      date: DateTime.now().add(const Duration(days: 2)),
      numberOfParkings: 12,
      amount: 120000,
    ),
    HowDidYouParkAndSpend(
      date: DateTime.now().add(const Duration(days: 3)),
      numberOfParkings: 18,
      amount: 180000,
    ),
    HowDidYouParkAndSpend(
      date: DateTime.now().add(const Duration(days: 4)),
      numberOfParkings: 14,
      amount: 140000,
    ),
  ];

  // PaymentMethodUsage Wallet and Other/Cash
  late List<PaymentMethodUsage> paymentMethodUsageList = [
    PaymentMethodUsage(
      method: 'Wallet',
      count: 15,
    ),
    PaymentMethodUsage(
      method: 'Other/Cash',
      count: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insights',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 20,
              ),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'How did you spend this month?',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ),
                ),

                // LineChart: Amount of money spent per day in this month
                chartContainer(
                  HowDidYouSpend(
                    howDidYouSpendList: howDidYouParkList,
                  ),
                ),

                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'How did you park this month?',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 18,
                          ),
                    ),
                  ),
                ),

                // BarChart: Number of parkings per day in this month
                chartContainer(
                  HowDidYouPark(
                    howDidYouParkList: howDidYouParkList,
                  ),
                ),

                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'How did you pay this month?',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 18,
                          ),
                    ),
                  ),
                ),

                // PieChart: Payment method usage in this month
                chartContainer(
                  HowDidYouPay(
                    paymentMethodUsageList: paymentMethodUsageList,
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_circle,
                      color: Theme.of(context).colorScheme.outline,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Paying by wallet will be faster and more convenient',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Container for chart widget
  Widget chartContainer(Widget chartWidget) {
    return ShadowContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.30,
      padding: const EdgeInsets.only(top: 15, right: 15),
      child: chartWidget,
    );
  }
}
