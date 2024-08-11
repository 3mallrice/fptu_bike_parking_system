import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../api/model/bai_model/statistic.dart';
import '../core/const/utilities/util_helper.dart';

class HowDidYouSpend extends StatelessWidget {
  final List<HowDidYouParkAndSpend> howDidYouSpendList;
  const HowDidYouSpend({
    super.key,
    required this.howDidYouSpendList,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: howDidYouSpendList.map((data) {
                  return FlSpot(
                    data.date.millisecondsSinceEpoch.toDouble(),
                    data.amount.toDouble(),
                  );
                }).toList(),
                isCurved: false,
                curveSmoothness: 0.2,
                color: Theme.of(context).colorScheme.primary,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.25)),
              ),
            ],

            //only boder bottom and right
            borderData: FlBorderData(
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1),
                right: const BorderSide(
                  color: Colors.transparent,
                ),
                left: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
                top: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (spot) =>
                    Theme.of(context).colorScheme.outline,
                tooltipRoundedRadius: 10,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    return LineTooltipItem(
                      '${UltilHelper.formatMoney(touchedSpot.y.round())} VND',
                      Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.bold,
                          ),
                    );
                  }).toList();
                },
              ),
            ),
            minX: howDidYouSpendList.isNotEmpty
                ? howDidYouSpendList.first.date.millisecondsSinceEpoch
                    .toDouble()
                : 0,
            maxX: howDidYouSpendList.isNotEmpty
                ? howDidYouSpendList.last.date.millisecondsSinceEpoch.toDouble()
                : 0,
            minY: 0,

            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    String day = '';
                    DateTime date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());

                    //format day
                    day = '${date.day}/${date.month}';

                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        day,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 40,
                  showTitles: true,
                  interval: 10000,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        UltilHelper.formatCurrency(value.round()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
