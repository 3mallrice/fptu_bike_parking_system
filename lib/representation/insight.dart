import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/how_did_you_park.dart';
import 'package:fptu_bike_parking_system/component/how_did_you_pay.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/statistic.dart';
import '../api/service/bai_be/statistic_service.dart';
import '../component/how_did_you_spent.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  static String routeName = '/insight_screen';

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  final callStatisticApi = StatisticApi();
  var log = Logger();

  //fake data for testing
  // HowDidYouPark
  List<HowDidYouParkAndSpend> howDidYouParkList = [
    HowDidYouParkAndSpend(
      date: DateTime.now(),
      numberOfParkings: 0,
      amount: 0,
    ),
    HowDidYouParkAndSpend(
      date: DateTime.now().subtract(const Duration(days: 1)),
      numberOfParkings: 0,
      amount: 0,
    ),
  ];

  // PaymentMethodUsage Wallet and Other/Cash
  late List<PaymentMethodUsage> paymentMethodUsageList = [
    PaymentMethodUsage(
      method: 'Wallet',
      count: 0,
    ),
    PaymentMethodUsage(
      method: 'Other/Cash',
      count: 0,
    ),
  ];

  Future<void> getStatisticData() async {
    final howDidYouParkResponse = await callStatisticApi.getHowDidYouPark();
    final howDidYouPayResponse = await callStatisticApi.getHowDidYouPay();

    // Kiểm tra tính hợp lệ của token và cập nhật dữ liệu nếu hợp lệ
    if (howDidYouParkResponse.isTokenValid &&
        howDidYouPayResponse.isTokenValid) {
      setState(() {
        howDidYouParkList = fillMissingDates(howDidYouParkResponse.data ?? []);
        paymentMethodUsageList = howDidYouPayResponse.data ?? [];
      });

      log.i(
          'HowDidYouPark response: ${fillMissingDates(howDidYouParkResponse.data ?? [])}');
      log.i('HowDidYouPay response: ${howDidYouPayResponse.data}');
    } else {
      log.e('Token is invalid');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatisticData();
  }

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
      body: RefreshIndicator(
        onRefresh: getStatisticData,
        child: Align(
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
                    howDidYouParkList: howDidYouParkList,
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
                    howDidYouParkList: howDidYouParkList,
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
                    paymentMethodUsageList: paymentMethodUsageList,
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          'Paying by wallet will be faster and more convenient',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Container for chart widget
  Widget chartContainer(Widget chartWidget,
      {List<HowDidYouParkAndSpend>? howDidYouParkList,
      List<PaymentMethodUsage>? paymentMethodUsageList}) {
    return ShadowContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.30,
      padding: const EdgeInsets.only(top: 15, right: 15),
      child: Stack(
        children: [
          chartWidget,
          if (howDidYouParkList == null &&
              // howDidYouParkList  &&
              paymentMethodUsageList?[0].count == 0 &&
              paymentMethodUsageList?[1].count == 0)
            Center(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.outline,
                ),
                child: Text(
                  'Don\'t have any data to show yet',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<HowDidYouParkAndSpend> fillMissingDates(
      List<HowDidYouParkAndSpend> data) {
    List<HowDidYouParkAndSpend> filledData = [];
    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(const Duration(days: 30));

    for (int i = 0; i <= 30; i++) {
      DateTime date = startDate.add(Duration(days: i));
      String formattedDate = UltilHelper.formatDateOnly(date);

      // Kiểm tra xem ngày này có trong data từ server hay không
      HowDidYouParkAndSpend? entry = data.firstWhere(
        (element) => UltilHelper.formatDateOnly(element.date) == formattedDate,
        orElse: () => HowDidYouParkAndSpend(
          date: date,
          numberOfParkings: 0,
          amount: 0,
        ),
      );

      filledData.add(entry);
    }

    return filledData;
  }
}
