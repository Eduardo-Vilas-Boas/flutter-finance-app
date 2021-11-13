import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/models/Category.dart';

class BarChartImplementation extends StatelessWidget {
  final List<dynamic> categorySpending;

  const BarChartImplementation({required this.categorySpending, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40),
        child: BarChart(
          BarChartData(
            barTouchData: barTouchData,
            titlesData: titlesData,
            borderData: borderData,
            barGroups: barGroups,
            alignment: BarChartAlignment.spaceAround,
          ),
        ));
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 20,
          getTitles: (double value) {
            print("value: " + value.toString());

            return this.categorySpending[value.toInt()][0];
          },
        ),
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups => this.categorySpending.map((element) {
        List<Color> colors = [];
        Color color =
            Category.categoryDictionary[element[0]]![Category.color] as Color;
        print("element[0]: " + element[0].toString());
        print("color: " +
            Category.categoryDictionary[element[0]]![Category.color]
                .toString());

        colors.add(color);

        return BarChartGroupData(
          x: this.categorySpending.indexOf(element),
          barRods: [
            BarChartRodData(y: (element[1] * 1.0) as double, colors: colors)
          ],
          showingTooltipIndicators: [0],
        );
      }).toList();
}

class CategorySpendingChart extends StatefulWidget {
  final List<dynamic> categorySpending;

  const CategorySpendingChart({required this.categorySpending, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CategorySpendingChartState();
}

class CategorySpendingChartState extends State<CategorySpendingChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.white,
        child: BarChartImplementation(
            categorySpending: this.widget.categorySpending),
      ),
    );
  }
}
