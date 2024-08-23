import 'package:bai_system/component/how_did_you_pay.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/statistic.dart';
import '../api/service/bai_be/statistic_service.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  static String routeName = '/insight_screen';

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  final callStatisticApi = StatisticApi();
  var log = Logger();

  late HowDidYouParkAndSpend? howDidYouParkAndSpend;

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
        howDidYouParkAndSpend = howDidYouParkResponse.data;
        paymentMethodUsageList = howDidYouPayResponse.data ?? [];
      });

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
                        'How did you park this month?',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      insightNumberContainer(
                        'Total parking times',
                        howDidYouParkAndSpend?.totalTimePakedInThisMonth ?? 0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.06,
                      ),
                      insightNumberContainer(
                        'Total spending',
                        howDidYouParkAndSpend?.totalPaymentInThisMonth ?? 0,
                        isMoney: true,
                      ),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

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
                  insightContainer(
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
  Widget insightContainer(Widget insightWidget,
      {List<PaymentMethodUsage>? paymentMethodUsageList}) {
    return ShadowContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.30,
      padding: const EdgeInsets.only(top: 15, right: 15),
      child: Stack(
        children: [
          insightWidget,
          if (paymentMethodUsageList?[0].count == 0 &&
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

  Widget insightNumberContainer(String title, int number,
          {bool isMoney = false}) =>
      ShadowContainer(
        width: MediaQuery.of(context).size.width * 0.42,
        height: MediaQuery.of(context).size.width * 0.2,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isMoney ? UltilHelper.formatMoney(number) : '$number',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Text(
                    isMoney ? 'VND' : 'times',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
