import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../api/model/bai_model/chart.dart';

class HowDidYouPark extends StatelessWidget {
  final List<HowDidYouParkAndSpend> howDidYouParkList;
  const HowDidYouPark({
    super.key,
    required this.howDidYouParkList,
  });

  @override
  Widget build(BuildContext context) {
    //Bar chart for HowDidYouPark
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: howDidYouParkList.map((data) {
              return BarChartGroupData(
                x: data.date.day,
                barRods: [
                  BarChartRodData(
                    toY: data.numberOfParkings.toDouble(),
                    color: Theme.of(context).colorScheme.primary,
                    width: 16.5,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ],
              );
            }).toList(),

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
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (spot) =>
                    Theme.of(context).colorScheme.outline,
                tooltipRoundedRadius: 10,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${howDidYouParkList[groupIndex].numberOfParkings}',
                    TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    String day = '';
                    for (var data in howDidYouParkList) {
                      if (data.date.day == value) {
                        //format Aug 01
                        day = data.date.day.toString();
                      }
                    }
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
                  interval: 2,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        value.toInt().toString(),
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
