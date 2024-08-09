import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  static String routeName = '/insight_screen';

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insight',
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
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                ShadowContainer(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          '2000 transactions in this month',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 200, // Set the desired width
                        height: 200, // Set the desired height
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                color: Theme.of(context).colorScheme.primary,
                                spots: [
                                  FlSpot(0, 1),
                                  FlSpot(1, 1.5),
                                  FlSpot(2, 1.4),
                                  FlSpot(3, 3.4),
                                  FlSpot(4, 2),
                                ],
                                isCurved: true,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ShadowContainer(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          '2000 transactions in this month',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 200, // Set the desired width
                        height: 200, // Set the desired height
                        child: PieChart(
                          swapAnimationDuration:
                              const Duration(milliseconds: 800),
                          swapAnimationCurve: Curves.easeInOutQuint,
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Theme.of(context).colorScheme.primary,
                                value: 40,
                                title: '40%',
                              ),
                              PieChartSectionData(
                                color: Theme.of(context).colorScheme.outline,
                                value: 30,
                                title: '30%',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
