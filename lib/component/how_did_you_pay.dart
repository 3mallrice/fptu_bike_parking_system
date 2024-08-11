import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../api/model/bai_model/statistic.dart';

class HowDidYouPay extends StatelessWidget {
  final List<PaymentMethodUsage> paymentMethodUsageList;
  const HowDidYouPay({
    super.key,
    required this.paymentMethodUsageList,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: PieChart(
          PieChartData(
            sections: paymentMethodUsageList.map((data) {
              return PieChartSectionData(
                value: data.count.toDouble(),
                title: data.method,
                titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                color: data.method == "Wallet"
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                badgePositionPercentageOffset: 1.35,
                badgeWidget: Text(
                  '${data.count}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                showTitle: true,
                titlePositionPercentageOffset: 0.45,
                radius: 65,
              );
            }).toList(),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 2,
            centerSpaceRadius: 50,
            centerSpaceColor: Theme.of(context).colorScheme.surface,
            startDegreeOffset: 180,
          ),
        ),
      ),
    );
  }
}
